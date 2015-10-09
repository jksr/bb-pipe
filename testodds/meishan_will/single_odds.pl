#Created by Meishan Lin 11/13/2014
#Function: Derive single body potential energy for 2014withToxin dataset
#         (1) potential with 8 regions defined by Jackups (JMB 2005)
#         (2) potential with 9 regions defined by Meishan
#Command: perl single.pl filewithTMresidueinfo (ex: all.sidechain for 2014withToxin dataset)

use Cwd;
$dir=getcwd();
$file=shift @ARGV;

open (IN,"<$file") || die "Cannot open input file $file\n";

#Jackups defined 8 regions
%ecap=();    # 13.5 < z-coord <= 20.5
%ehg_in=();  # 6.5  < z-coord <=13.5; pore-facing sidechain 
%ehg_out=(); # 6.5  < z-coord <=13.5; lipid-facing sidechain 
%core_in=(); # -6.5 <=z-coord <=6.5; pore-facing sidechain 
%core_out=();# -6.5 <=z-coord <=6.5; lipid-facing sidechain 
%phg_in=();  #-13.5 <=z-coord <-6.5; pore-facing sidechain 
%phg_out=(); #-13.5 <=z-coord <-6.5; lipid-facing sidechain 
%pcap=();    #-20.5 <=z-coord <-13.5; pore-facing sidechain 
#Meishan defined one extra region in the extracellular side
%lps=();     # 20.5 < z-coord <= 30 

@aa=('A','R','N','D','C','Q','E','G','H','I','L','K','M','F','P','S','T','W','Y','V');
%aacount=(); #store the amino type count in all 8 regions;
%aacount9=(); #store the amino type count in all 9 regions;
while ($line=<IN>)
{
 chomp $line;
 @arr=split ("\t",$line);
 $aa=$arr[2];
 $face=$arr[3];
 $zcoord=$arr[4];
 #printf "%s\t%s\t%.2f\n",$aa,$face,$zcoord; 
if ((13.5 <$zcoord) and ($zcoord <= 20.5)) {$ecap{$aa}++; $aacount{$aa}++;}
if ((6.5  <$zcoord) and ($zcoord <= 13.5) and ($face eq "IN")) {$ehg_in{$aa}++; $aacount{$aa}++;}
if ((6.5  <$zcoord) and ($zcoord <= 13.5) and ($face eq "OUT")) {$ehg_out{$aa}++; $aacount{$aa}++;}
if ((-6.5 <=$zcoord) and ($zcoord <= 6.5) and ($face eq "IN")) {$core_in{$aa}++; $aacount{$aa}++;}
if ((-6.5 <=$zcoord) and ($zcoord <= 6.5) and ($face eq "OUT")) {$core_out{$aa}++; $aacount{$aa}++;}
if ((-13.5 <=$zcoord) and ($zcoord < -6.5)and ($face eq "IN")) {$phg_in{$aa}++; $aacount{$aa}++;}
if ((-13.5 <=$zcoord) and ($zcoord < -6.5)and ($face eq "OUT")) {$phg_out{$aa}++; $aacount{$aa}++;}
if ((-20.5 <=$zcoord) and ($zcoord < -13.5)) {$pcap{$aa}++; $aacount{$aa}++;}
if ((20.5 <$zcoord) and ($zcoord <= 30)) {$lps{$aa}++; }
}
$ecap_count=regioncount (%ecap);
$ehg_in_count=regioncount (%ehg_in);
$ehg_out_count=regioncount(%ehg_out);
$core_in_count=regioncount (%core_in);
$core_out_count=regioncount (%core_out);
$phg_in_count=regioncount (%phg_in);
$phg_out_count=regioncount (%phg_out);
$pcap_count=regioncount (%pcap);

#Derive potential energy for 8 regions (defined by Jackups)
$all8_count=regioncount (%aacount); #total number of residues in 8 regions

($etem)=single_potential8(%ecap);
%potential_ecap=%$etem; 

($etem)=single_potential8(%ehg_in);
%potential_ehg_in=%$etem;

($etem)=single_potential8(%ehg_out);
%potential_ehg_out=%$etem;

($etem)=single_potential8(%core_in);
%potential_core_in=%$etem;

($etem)=single_potential8(%core_out);
%potential_core_out=%$etem;

($etem)=single_potential8(%phg_in);
%potential_phg_in=%$etem; 

($etem)=single_potential8(%phg_out);
%potential_phg_out=%$etem;

($etem)=single_potential8(%pcap);
%potential_pcap=%$etem;

#print potential energy

open (ECAP,">$dir/ECap.odds") || die "Cannot creat output file ecap.odds\n";
open (EHGIN,">$dir/ExtraIn.odds") || die "Cannot creat output file ehg.in.odds\n";
open (EHGOUT,">$dir/ExtraOut.odds") || die "Cannot creat output file ehg.out.odds\n";
open (COREIN,">$dir/CoreIn.odds") || die "Cannot creat output file core.in.odds\n";
open (COREOUT,">$dir/CoreOut.odds") || die "Cannot creat output file core.out.odds\n";
open (PHGIN,">$dir/PeriIn.odds") || die "Cannot creat output file phg.in.odds\n";
open (PHGOUT,">$dir/PeriOut.odds") || die "Cannot creat output file phg.out.odds\n";
open (PCAP,">$dir/PCap.odds") || die "Cannot creat output file pcap.odds\n";

foreach $myaa (@aa)
{
 printf ECAP     "%.3f\n",$potential_ecap{$myaa};
 printf EHGIN    "%.3f\n",$potential_ehg_in{$myaa};
 printf EHGOUT   "%.3f\n",$potential_ehg_out{$myaa};
 printf COREIN   "%.3f\n",$potential_core_in{$myaa};
 printf COREOUT  "%.3f\n",$potential_core_out{$myaa};
 printf PHGIN    "%.3f\n",$potential_phg_in{$myaa};
 printf PHGOUT   "%.3f\n",$potential_phg_out{$myaa};
 printf PCAP     "%.3f\n",$potential_pcap{$myaa};
 #printf ECAP "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$ecap{$myaa},$aacount{$myaa},$ecap_count,$all8_count,$potential_ecap{$myaa};
 #printf EHGIN "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$ehg_in{$myaa},$aacount{$myaa},$ehg_in_count,$all8_count,$potential_ehg_in{$myaa};
 #printf EHGOUT "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$ehg_out{$myaa},$aacount{$myaa},$ehg_out_count,$all8_count,$potential_ehg_out{$myaa};
 #printf COREIN "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$core_in{$myaa},$aacount{$myaa},$core_in_count,$all8_count,$potential_core_in{$myaa};
 #printf COREOUT "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$core_out{$myaa},$aacount{$myaa},$core_out_count,$all8_count,$potential_core_out{$myaa};
 #printf PHGIN "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$phg_in{$myaa},$aacount{$myaa},$phg_in_count,$all8_count,$potential_phg_in{$myaa};
 #printf PHGOUT "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$phg_out{$myaa},$aacount{$myaa},$phg_out_count,$all8_count,$potential_phg_out{$myaa};
 #printf PCAP "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$pcap{$myaa},$aacount{$myaa},$pcap_count,$all8_count,$potential_pcap{$myaa};
}


###### Derive potential energy with 9 regions (defined by Meishan)
%aacount9=%aacount;
foreach $myaa (@aa)
{$aacount9{$myaa}+=$lps{$myaa};
}
$lps_count=regioncount (%lps);
$all9_count=regioncount (%aacount9);

($etem)=single_potential9(%lps);
%potential9_lps=%$etem;


($etem)=single_potential9(%ecap);
%potential9_ecap=%$etem;

($etem)=single_potential9(%ehg_in);
%potential9_ehg_in=%$etem;

($etem)=single_potential9(%ehg_out);
%potential9_ehg_out=%$etem;

($etem)=single_potential9(%core_in);
%potential9_core_in=%$etem;

($etem)=single_potential9(%core_out);
%potential9_core_out=%$etem;

($etem)=single_potential9(%phg_in);
%potential9_phg_in=%$etem;

($etem)=single_potential9(%phg_out);
%potential9_phg_out=%$etem;

($etem)=single_potential9(%pcap);
%potential9_pcap=%$etem;

##print potential energy
#open (LPS, ">$dir/odds/lps.odds.9") || die "Cannot create output file lps.odds.9\n";
#open (ECAP2,">$dir/odds/ecap.odds.9") || die "Cannot creat output file ecap.odds.9\n";
#open (EHGIN2,">$dir/odds/ehg.in.odds.9") || die "Cannot creat output file ehg.in.odds.9\n";
#open (EHGOUT2,">$dir/odds/ehg.out.odds.9") || die "Cannot creat output file ehg.out.odds.9\n";
#open (COREIN2,">$dir/odds/core.in.odds.9") || die "Cannot creat output file core.in.odds.9\n";
#open (COREOUT2,">$dir/odds/core.out.odds.9") || die "Cannot creat output file core.out.odds.9\n";
#open (PHGIN2,">$dir/odds/phg.in.odds.9") || die "Cannot creat output file phg.in.odds.9\n";
#open (PHGOUT2,">$dir/odds/phg.out.odds.9") || die "Cannot creat output file phg.out.odds.9\n";
#open (PCAP2,">$dir/odds/pcap.odds.9") || die "Cannot creat output file pcap.odds.9\n";
#
#foreach $myaa (@aa)
#{
# printf LPS   "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$lps{$myaa},$aacount9{$myaa},$lps_count,$all9_count,$potential9_lps{$myaa};
# printf ECAP2 "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$ecap{$myaa},$aacount9{$myaa},$ecap_count,$all9_count,$potential9_ecap{$myaa};
# printf EHGIN2 "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$ehg_in{$myaa},$aacount9{$myaa},$ehg_in_count,$all9_count,$potential9_ehg_in{$myaa};
# printf EHGOUT2 "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$ehg_out{$myaa},$aacount9{$myaa},$ehg_out_count,$all9_count,$potential9_ehg_out{$myaa};
# printf COREIN2 "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$core_in{$myaa},$aacount9{$myaa},$core_in_count,$all9_count,$potential9_core_in{$myaa};
# printf COREOUT2 "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$core_out{$myaa},$aacount9{$myaa},$core_out_count,$all9_count,$potential9_core_out{$myaa};
# printf PHGIN2 "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$phg_in{$myaa},$aacount9{$myaa},$phg_in_count,$all9_count,$potential9_phg_in{$myaa};
# printf PHGOUT2 "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$phg_out{$myaa},$aacount9{$myaa},$phg_out_count,$all9_count,$potential9_phg_out{$myaa};
# printf PCAP2 "%s\t%d\t%d\t%d\t%d\t%.3f\n",$myaa,$pcap{$myaa},$aacount9{$myaa},$pcap_count,$all9_count,$potential9_pcap{$myaa};
#}
#
sub single_potential8
{
 my %region=@_;
 my %potential=();
 my %pvalue=();
 foreach my $myaa (@aa)
 {
  my $xregion=$region{$myaa}; #residue $myaa count in region (n_rx) 
  my $rcount=regioncount (%region); #all residue count in region (n_r)
  my $xcount=$aacount{$myaa}; #residue $myaa count in all 8 region; (n_x)
  #printf "%s\t%d\t%d\t%d\n",$myaa,$rcount,$xcount,$all8_count;

  if ( ($rcount==0) or ($xcount==0) or ($all8_count==0) ){
	$potential{$myaa}=1; # n=all residue counts in all regions
  }
  else{
	$potential{$myaa}=($xregion/$rcount)/($xcount/$all8_count); #P_r(x)=n_rx/(n_r*n_x/n); n=all residue counts in all regions
	}
 }
 return (\%potential);
}

sub single_potential9
{
 my %region=@_;
 my %potential=();
 my %pvalue=();
 foreach my $myaa (@aa)
 {
  my $xregion=$region{$myaa}; #residue $myaa count in region (n_rx) 
  my $rcount=regioncount (%region); #all residue count in region (n_r)
  my $xcount=$aacount9{$myaa}; #residue $myaa count in all 9 region; (n_x)
  if ( ($rcount==0) or ($xcount==0) or ($all8count==0) ){
	$potential{$myaa}=1;
  }
  else{
	$potential{$myaa}=($xregion/$rcount)/($xcount/$all9_count); #P_r(x)=n_rx/(n_r*n_x/n); n=all residue counts in all regions
  }
 }
 return (\%potential);
}

sub regioncount
{my %myregion=@_;
 my $count=0;
foreach $myaa (@aa)
{#printf "%s\t%d\n",$myaa, $myregion{$myaa};
 $count+=$myregion{$myaa};
}
#print $count,"\n";
 return $count;
}
