#include "typedefs.h"

#include "lut.h"

// wrapper for the streamin part
// prevent incorrect flattening
void read_data(VectorDataType  data[NUM_FEATURES * NUM_TRAINING / D_VECTOR_SIZE], 
               DataType        training_instance[NUM_FEATURES],
               int training_id)
{
  // #pragma HLS inline
  const int unroll_factor = PAR_FACTOR;
  #pragma HLS array_partition variable=training_instance cyclic factor=unroll_factor

  READ_TRAINING_DATA: for (int i = 0; i < NUM_FEATURES / D_VECTOR_SIZE; i ++ )
  {
    #pragma HLS PIPELINE II=1
    VectorFeatureType tmp_data = data[training_id * NUM_FEATURES / D_VECTOR_SIZE + i];
    READ_TRAINING_DATA_INNER: for (int j = 0; j < D_VECTOR_SIZE; j ++ )
      training_instance[i * D_VECTOR_SIZE + j].range(DTYPE_TWIDTH-1, 0) = tmp_data.range((j+1)*DTYPE_TWIDTH-1, j*DTYPE_TWIDTH);
  }
}


// Function to compute the dot product of data (feature) vector and parameter vector
FeatureType dotProduct(FeatureType param[NUM_FEATURES],
                       DataType    feature[NUM_FEATURES])
{
  #pragma HLS INLINE

  FeatureType result = 0;
  DOT: for (int i = 0; i < NUM_FEATURES / PAR_FACTOR; i++)
  {
    #pragma HLS PIPELINE II=1
    DOT_INNER: for(int j = 0; j < PAR_FACTOR; j++) 
    {
      FeatureType term = param[i*PAR_FACTOR+j] * feature[i*PAR_FACTOR+j];
      result += term;
    }
  }
  return result;
}

// values of sigmoid function stored in a look-up table
FeatureType useLUT(FeatureType in) 
{ 
  #pragma HLS INLINE
  IdxFixed index;
  if (in < 0)
  {
    in = -in;
    index = (IdxFixed)LUT_SIZE - (IdxFixed)(((TmpFixed)in) << (LUTIN_TWIDTH - LUTIN_IWIDTH));  
  } 
  else 
    index = ((TmpFixed)in) << (LUTIN_TWIDTH - LUTIN_IWIDTH);  
  return lut[index];
}

// Function to compute the probability. The Sigmoid function is implemented using BRAMS 
// to store the value of Sigmoid function for values relevant to this application
FeatureType Sigmoid(FeatureType exponent) 
{
  #pragma HLS INLINE
  if (exponent > 4) 
    return 1.0;
  else if (exponent < -4) 
    return 0.0;
  else 
  {
    LutInFixed inLut = (LutInFixed)exponent;
    return useLUT(inLut);
  } 
}

// Compute the gradient of the cost function
void computeGradient(
    FeatureType grad[NUM_FEATURES],
    DataType    feature[NUM_FEATURES],
    FeatureType scale)
{
  #pragma HLS INLINE
  GRAD: for (int i = 0; i < NUM_FEATURES / PAR_FACTOR; i++)
  {
    #pragma HLS PIPELINE II=1
    GRAD_INNER: for (int j = 0; j < PAR_FACTOR; j++)
      grad[i*PAR_FACTOR+j] = (scale * feature[i*PAR_FACTOR+j]);
  }
}

// Update the parameter vector
void updateParameter(
    FeatureType param[NUM_FEATURES],
    FeatureType grad[NUM_FEATURES],
    FeatureType scale)
{
  #pragma HLS INLINE
  const int unroll_factor = PAR_FACTOR;

  UPDATE: for (int i = 0; i < NUM_FEATURES / PAR_FACTOR; i++)
  {
    #pragma HLS PIPELINE II=1
    UPDATE_INNER: for (int j = 0; j < PAR_FACTOR; j++)
      param[i*PAR_FACTOR+j] += scale * grad[i*PAR_FACTOR+j];
  }
}



// wrapper, wraps the compute part for dataflow
void compute(FeatureType theta_local[NUM_FEATURES], 
             LabelType label_local[NUM_TRAINING],
             DataType training_instance[NUM_FEATURES],
             int training_id)
{
  // array for storing gradient
  static FeatureType gradient[NUM_FEATURES];
  const int unroll_factor = PAR_FACTOR;
  #pragma HLS array_partition variable=gradient cyclic factor=unroll_factor

  // step size
  FeatureType step = STEP_SIZE;

  // do dot product with the parameter vector
  FeatureType dot = dotProduct(theta_local, training_instance);
  // do sigmoid function
  FeatureType prob = Sigmoid(dot);
  // get the label
  LabelType training_label = label_local[training_id];
  // compute gradient
  computeGradient(gradient, training_instance, (prob-training_label));
  // update the param vector
  updateParameter(theta_local, gradient, -step);
}



extern "C"
{
  void spam_filter( VectorDataType    data[NUM_FEATURES * NUM_TRAINING / D_VECTOR_SIZE],
              VectorLabelType   label[NUM_TRAINING / L_VECTOR_SIZE],
              VectorFeatureType theta[NUM_FEATURES / F_VECTOR_SIZE]
              )
  {
#pragma HLS INTERFACE m_axi port=data bundle=aximm1
#pragma HLS INTERFACE m_axi port=label bundle=aximm2
#pragma HLS INTERFACE m_axi port=theta bundle=aximm1

    // intermediate variables 
    const int unroll_factor = PAR_FACTOR;

    // local version of the parameters
    static FeatureType theta_local[NUM_FEATURES];
    #pragma HLS array_partition variable=theta_local cyclic factor=unroll_factor
    // local buffer of labels
    static LabelType   label_local[NUM_TRAINING];
    #pragma HLS array_partition variable=label_local cyclic factor=L_VECTOR_SIZE
    // array for storing one training instance
    static DataType training_instance[NUM_FEATURES];
    #pragma HLS array_partition variable=training_instance cyclic factor=unroll_factor

    // initialize local parameters
    PARAM_INIT: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE; i ++ )
    {
      #pragma HLS pipeline
      // VectorFeatureType tmp_theta = theta[i];
      PARAM_INIT_INNER: for (int j = 0; j < F_VECTOR_SIZE; j ++ ){
        theta_local[i * F_VECTOR_SIZE + j].range(FTYPE_TWIDTH-1, 0) = 0;
        // theta_local[i * F_VECTOR_SIZE + j].range(FTYPE_TWIDTH-1, 0) = tmp_theta.range((j+1)*FTYPE_TWIDTH-1, j*FTYPE_TWIDTH);
      }
    }

    // copy in labels
    LABEL_CP: for (int i = 0; i < NUM_TRAINING / L_VECTOR_SIZE; i ++ )
    {
    #pragma HLS PIPELINE II=1
      VectorLabelType tmp_label = label[i];
      LABEL_CP_INNER: for (int j = 0; j < L_VECTOR_SIZE; j ++ )
        label_local[i * L_VECTOR_SIZE + j].range(LTYPE_WIDTH-1, 0) = tmp_label.range((j+1)*LTYPE_WIDTH-1, j*LTYPE_WIDTH);
    }
  
    // main loop
    // runs for multiple epochs
    EPOCH: for (int epoch = 0; epoch < NUM_EPOCHS; epoch ++) 
    {
      // in each epoch, go through each training instance in sequence
      TRAINING_INST: for( int training_id = 0; training_id < NUM_TRAINING; training_id ++ )
      {  
        #pragma HLS DATAFLOW
        // first reads in the training instance
        read_data(data, training_instance, training_id);
        // compute part
        compute(theta_local, label_local, training_instance, training_id);
      }
    }

    // stream out the result
    STREAM_OUT: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE; i ++ )
    {
    #pragma HLS PIPELINE II=1
      VectorFeatureType tmp_theta = 0;
      STREAM_OUT_INNER: for (int j = 0; j < F_VECTOR_SIZE; j ++ )
        tmp_theta.range((j+1)*FTYPE_TWIDTH-1, j*FTYPE_TWIDTH) = theta_local[i * F_VECTOR_SIZE + j].range(FTYPE_TWIDTH-1, 0);
      theta[i] = tmp_theta;
    }
  }
}
