perl detshear.pl 1BXW.dssp 1BXW.precom 1BXW 1 8
perl detshear.pl 1QJ8.dssp 1QJ8.precom 1QJ8 2 8
perl detshear.pl 1P4T.dssp 1P4T.precom 1P4T 3 8
perl detshear.pl 1K24.dssp 1K24.precom 1K24 4 10
perl detshear.pl 1I78.dssp 1I78.precom 1I78 5 10
perl detshear.pl 1QD6.dssp 1QD6.precom 1QD6 6 12
perl detshear.pl 2POR.dssp 2POR.precom 2POR 7 16
perl detshear.pl 1PRN.dssp 1PRN.precom 1PRN 8 16
perl detshear.pl 2OMF.dssp 2OMF.precom 2OMF 9 16
perl detshear.pl 1E54.dssp 1E54.precom 1E54 10 16
perl detshear.pl 2MPR.dssp 2MPR.precom 2MPR 11 18
perl detshear.pl 1A0S.dssp 1A0S.precom 1A0S 12 18
perl detshear.pl 1FEP.dssp 1FEP.precom 1FEP 13 22
perl detshear.pl 2FCP.dssp 2FCP.precom 2FCP 14 22
perl detshear.pl 1KMO.dssp 1KMO.precom 1KMO 15 22
perl detshear.pl 1NQE.dssp 1NQE.precom 1NQE 16 22
perl detshear.pl 1UYN.dssp 1UYN.precom 1UYN 19 12
cat *.precom > runallpred.com
chmod +x runallpred.com