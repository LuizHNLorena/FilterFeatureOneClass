rank1 = InformationScore.execute('iris1.data');
rank2 = PearsonCorrelation.execute('iris1.data');
rank3 = IntraClassDistance.execute('iris1.data');
rank4 = InterquartileRange.execute('iris1.data');
disp(rank1);
disp(rank2);
disp(rank3);
disp(rank4);