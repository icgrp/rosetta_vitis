/*===============================================================*/
/*                                                               */
/*                       testing_data.h                          */
/*                                                               */
/*              Constant array for test instances.               */
/*                                                               */
/*===============================================================*/


#ifndef TESTING_DATA_H
#define TESTING_DATA_H

const DigitType testing_data[NUM_TEST * DIGIT_WIDTH] = {
  #include "/home/ylxiao/rosetta/digit-recognition/196data/test_set.dat"
};

const LabelType expected[NUM_TEST] = {
  #include "/home/ylxiao/rosetta/digit-recognition/196data/expected.dat"
};

#endif
