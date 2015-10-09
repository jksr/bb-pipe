perl getpairs.pl ../inputs/1ek9/1ek9.dssp contacts/1ek9.strong contacts/1ek9.vdw contacts/1ek9.weak  1  4
perl getpairs.pl ../inputs/2f1c/2f1c.dssp contacts/2f1c.strong contacts/2f1c.vdw contacts/2f1c.weak  2 14
perl getpairs.pl ../inputs/1p4t/1p4t.dssp contacts/1p4t.strong contacts/1p4t.vdw contacts/1p4t.weak  3  8
perl getpairs.pl ../inputs/1bxw/1bxw.dssp contacts/1bxw.strong contacts/1bxw.vdw contacts/1bxw.weak  4  8
perl getpairs.pl ../inputs/1k24/1k24.dssp contacts/1k24.strong contacts/1k24.vdw contacts/1k24.weak  5 10
perl getpairs.pl ../inputs/1qj8/1qj8.dssp contacts/1qj8.strong contacts/1qj8.vdw contacts/1qj8.weak  6  8
perl getpairs.pl ../inputs/1qd6/1qd6.dssp contacts/1qd6.strong contacts/1qd6.vdw contacts/1qd6.weak  7 12
perl getpairs.pl ../inputs/1t16/1t16.dssp contacts/1t16.strong contacts/1t16.vdw contacts/1t16.weak  8 14
perl getpairs.pl ../inputs/2f1t/2f1t.dssp contacts/2f1t.strong contacts/2f1t.vdw contacts/2f1t.weak  9  8
perl getpairs.pl ../inputs/1i78/1i78.dssp contacts/1i78.strong contacts/1i78.vdw contacts/1i78.weak 10 10
perl getpairs.pl ../inputs/1prn/1prn.dssp contacts/1prn.strong contacts/1prn.vdw contacts/1prn.weak 11 16
perl getpairs.pl ../inputs/1uyn/1uyn.dssp contacts/1uyn.strong contacts/1uyn.vdw contacts/1uyn.weak 12 12
perl getpairs.pl ../inputs/1e54/1e54.dssp contacts/1e54.strong contacts/1e54.vdw contacts/1e54.weak 13 16
perl getpairs.pl ../inputs/1thq/1thq.dssp contacts/1thq.strong contacts/1thq.vdw contacts/1thq.weak 14  8
perl getpairs.pl ../inputs/2o4v/2o4v.dssp contacts/2o4v.strong contacts/2o4v.vdw contacts/2o4v.weak 15 16
perl getpairs.pl ../inputs/2mpr/2mpr.dssp contacts/2mpr.strong contacts/2mpr.vdw contacts/2mpr.weak 16 18
perl getpairs.pl ../inputs/1kmo/1kmo.dssp contacts/1kmo.strong contacts/1kmo.vdw contacts/1kmo.weak 17 22
perl getpairs.pl ../inputs/1nqe/1nqe.dssp contacts/1nqe.strong contacts/1nqe.vdw contacts/1nqe.weak 18 22
perl getpairs.pl ../inputs/1a0s/1a0s.dssp contacts/1a0s.strong contacts/1a0s.vdw contacts/1a0s.weak 19 18
perl getpairs.pl ../inputs/1fep/1fep.dssp contacts/1fep.strong contacts/1fep.vdw contacts/1fep.weak 20 22
perl getpairs.pl ../inputs/7ahl/7ahl.dssp contacts/7ahl.strong contacts/7ahl.vdw contacts/7ahl.weak 21  2
perl getpairs.pl ../inputs/2omf/2omf.dssp contacts/2omf.strong contacts/2omf.vdw contacts/2omf.weak 22 16
perl getpairs.pl ../inputs/1xkw/1xkw.dssp contacts/1xkw.strong contacts/1xkw.vdw contacts/1xkw.weak 23 22
perl getpairs.pl ../inputs/2fcp/2fcp.dssp contacts/2fcp.strong contacts/2fcp.vdw contacts/2fcp.weak 24 22
perl getpairs.pl ../inputs/2por/2por.dssp contacts/2por.strong contacts/2por.vdw contacts/2por.weak 25 16
cat contacts/*.strong > contacts/25.strong
cat contacts/*.vdw > contacts/25.vdw
cat contacts/*.weak > contacts/25.weak
