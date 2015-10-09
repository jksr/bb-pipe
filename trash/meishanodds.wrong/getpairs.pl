#Created by Meishan Lin 11/17/2014
#Function: get the interstrand pairs from DSSP
#Input: $pr: protein name
#       $chain: protein chain 
#       $pr.sidechain: file contains tm strand residue information (index;res type;sidechain direction;z-coord)
 
$pr = lc(shift @ARGV);
$chain = uc(shift @ARGV);

open(DSSP, "</home/mlin/2014DataSet/DSSP/$pr.dssp") || die "Can't open $a.dssp file";
open(COORD, "</home/mlin/2014DataSet/TMSTRAND/$pr.sidechain") || die "cant open sidechain file";
open(STRONG, ">./contact/$pr.strong");
open(VDW, ">./contact/$pr.vdw");
open(WEAK, ">./contact/$pr.weak");

#$prid = shift @ARGV;
#$strandnum = shift @ARGV;

$strandnum=0;
$lastindex=-200;
while(<COORD>) {
    chomp;
    @arr = split("\t", $_);
    $index=$arr[0];
    $zcoord=$arr[4];
    if ($index ne ($lastindex+1)) {$strandnum++;}
    $lastindex=$index;
 
    $strand{$index} = $strandnum;
    $amino{$index} = aa_int($arr[2]);

    if ($arr[3] eq "IN") {$face{$index}=1;}
    elsif ($arr[3] eq "OUT") {$face{$index}=2;}
       else {print "Invalid sidechain direction $arr[3] !\n"; exit;}

    if ((20.5 <$zcoord) and ($zcoord <= 30)) {$region{$index}=6; }
    elsif ((13.5 <$zcoord) and ($zcoord <= 20.5)) {$region{$index}=5;} 
       elsif ((6.5  <$zcoord) and ($zcoord <= 13.5)) {$region{$index}=4;} 
          elsif ((-6.5 <=$zcoord) and ($zcoord <= 6.5)) {$region{$index}=3;} 
             elsif ((-13.5 <=$zcoord) and ($zcoord < -6.5)) {$region{$index}=2;} 
              elsif ((-20.5 <=$zcoord) and ($zcoord < -13.5)) {$region{$index}=1;}
                 else {$region{$index}=0;}

   #printf "%d\t%d\t%d\t%d\t%d\n",$index,$strand{$index},$amino{$index},$region{$index},$face{$index};
}
print "Total $strandnum of TM strands in $pr\n";

$tag = 0;
while($line=<DSSP>) 
{
    chomp $line;
    if ($line ne "")
    { 
       $flag = substr($line,2,1);       
       $mychain = substr($line, 11,1);
       if(($tag == 1) and (substr($line,13,1) ne "!")) 
       {       
          
       if (substr($line,5,5)<0) {print $line,"\n"; next;} #negative residue index; skip      
      ($index,$res0,$mychain,$aa0)=$line=~/^\s+(\d+)\s+(\d+)\s+(\S)\s+(\S)/;
        $res[$index]=$res0;
        $aa[$index]=$aa0;
             if (($aa[$index] eq "a")or ($aa[$index] eq "b")){$aa[$index]="C";}
       if ($aa[$index] eq "X"){$aa[$index]="M";}
       printf "%d\t%d\t%s\t%d\n",$index,$res[$index],$aa[$index],$aaid[$index];

       $aaid[$index]=aa_int($aa[$index]);
       #printf "%d\t%d\t%s\t%d\n",$index,$res[$index],$aa[$index],$aaid[$index];
       if ($chain eq $mychain)
       {    
        $bp1[$index] = substr($line,25,4); # Beta bridge partner one
	$bp2[$index] = substr($line,29,4); # Beta bridge partner two
        $hbond1[$index] = substr($line,40,5)+$index; # N-H-->O=C H-bond partner
        $hbond2[$index] = substr($line,50,6)+ $index; # C=O-->H-N H-bond partner
        }   
        if (exists $strand{$res[$index]})   
        {
         $strandc[$index] = $strand{$res[$index]}; #strand number info from .coord file
         $pos[$index] = $region{$res[$index]}; #Res positional info from .coord file
         $facing[$index] = $face{$res[$index]}; #Res directional info from .coord file
        # printf "%d\t%d\t%d\t%d\t%d\n",$index,$strandc[$index],$aaid[$indeix],$pos[$index],$facing[$index];	
        }
        else {#printf "%d\t%d\n",$res[$index],$strand{$res[$index]};
              $strandc[$index]=0;}
        
	#printf "%4d\t%4d\t%4d\t%s\t%4d\t%4d\t%4d\t%4d\t%4d\t%4d\t%4d\n", $index, $res[$index], $strandc[$index], $aa[$index], $aaid[$index], $bp1[$index], $bp2[$index], $hbond1[$index],$hbond2[$index],$hbond3[$index],$hbond4[$index];
       #printf "%4d\t%4d\t%4d\t%4d\n",$strandc[$index],$aaid[$index],$pos[$index],$facing[$index];
      }
     if($flag eq "\#")
      {
	$tag = 1; 
      }
   }
}

$prid=0;
$indexnum = $index;
#print $indexnum;

for($i = 1 ; $i <= $indexnum ; $i++) 
{

    if(($bp1[$i] > 0) && ($strandc[$i] > 0) && ($strandc[$bp1[$i]] > 0)) 
      {
	if(($strandc[$i] == ($strandc[$bp1[$i]] - 1)) || (($strandc[$i] == $strandnum) && ($strandc[$bp1[$i]] == 1))) 
          {
	    $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$bp1[$i]]);
	    if($bp1[$i] == $hbond1[$i]) 
              { 
               printf STRONG "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid, $aaid[$i], $pos[$i], $facing[$i],$aaid[$bp1[$i]], $pos[$bp1[$i]], $facing[$bp1[$i]];
               #printf STRONG "%d %d %d %d %d %d %d %d %d\n", $pairid, $res[$i],$aaid[$i], $pos[$i], $facing[$i],$res[$bp1[$i]],$aaid[$bp1[$i]], $pos[$bp1[$i]], $facing[$bp1[$i]];
              }
	    else {
		  printf VDW "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid, $aaid[$i], $pos[$i], $facing[$i],$aaid[$bp1[$i]], $pos[$bp1[$i]], $facing[$bp1[$i]]; 
                #printf VDW "%d %d %d %d %d %d %d %d %d\n", $pairid, $res[$i], $aaid[$i], $pos[$i], $facing[$i],$res[$bp1[$i]],$aaid[$bp1[$i]], $pos[$bp1[$i]], $facing[$bp1[$i]]; 

                }
	   }
     }

    if(($bp2[$i] > 0) && ($strandc[$i] > 0) && ($strandc[$bp2[$i]] > 0)) 
      {
	if(($strandc[$i] == ($strandc[$bp2[$i]] - 1)) || (($strandc[$i] == $strandnum) && ($strandc[$bp2[$i]] == 1)))
         {
	    $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$bp2[$i]]);
	    
	    if($bp2[$i] == $hbond1[$i]) 
             {
		printf STRONG "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid, $aaid[$i],$pos[$i],$facing[$i], $aaid[$bp2[$i]],$pos[$bp2[$i]],$facing[$bp2[$i]];
              #printf STRONG "%d %d %d %d %d %d %d %d %d\n", $pairid, $res[$i],$aaid[$i],$pos[$i],$facing[$i],$res[$bp2[$i]], $aaid[$bp2[$i]],$pos[$bp2[$i]],$facing[$bp2[$i]];

             }
	    else 
             {
              #if(!((($bp1[$i] == 0)||($bp2[$i] == 0)) && ($aaid[$i] == 14) && ($strandc[$i]>0)&&(($strandc[$hbond2[$i]] == ($strandc[$i]+1)) || (($strandc[$i]== $strandnum) && ($strandc[$hbond2[$i]] == 1))))) # Pro-X strong H-bond

		{printf VDW "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid, $aaid[$i],$pos[$i],$facing[$i], $aaid[$bp2[$i]],$pos[$bp2[$i]],$facing[$bp2[$i]];
              #printf VDW "%d %d %d %d %d %d %d %d %d\n", $pairid, $res[$i],$aaid[$i],$pos[$i],$facing[$i], $res[$bp2[$i]],$aaid[$bp2[$i]],$pos[$bp2[$i]],$facing[$bp2[$i]];
              }

             }
	 }
    }

    if(($bp1[$i] > 0) && ($strandc[$i] > 0)) 
     {
	if(($strandc[$i] == ($strandc[$bp1[$i]-1] - 1)) || (($strandc[$i] == $strandnum) && ($strandc[$bp1[$i]-1] == 1))) 
         {
	    $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$bp1[$i]-1]);
           printf WEAK "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid, $aaid[$i], $pos[$i], $facing[$i],$aaid[$bp1[$i]-1], $pos[$bp1[$i]-1], $facing[$bp1[$i]-1];	
         }
    }

    if(($bp2[$i] > 0) && ($strandc[$i] > 0)) 
    {
	if(($strandc[$i] == ($strandc[$bp2[$i]-1] - 1)) || (($strandc[$i] == $strandnum) && ($strandc[$bp2[$i]-1] == 1))) 
          {
	    $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$bp2[$i]-1]);
	    printf WEAK "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid, $aaid[$i],$pos[$i],$facing[$i], $aaid[$bp2[$i]-1],$pos[$bp2[$i]-1],$facing[$bp2[$i]-1];
          }
    }
    
   if((($bp1[$i] == 0)||($bp2[$i] == 0)) && ($aaid[$hbond1[$i]]==14) && ($strandc[$i]>0)&& (($strandc[$hbond1[$i]]== ($strandc[$i]+1)) || (($strandc[$i]== $strandnum) && ($strandc[$hbond1[$i]]==1)))) # X-Pro strong H-bond
    { 
      $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$hbond1[$i]]);
      printf STRONG "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid, $aaid[$i],$pos[$i],$facing[$i],$aaid[$hbond1[$i]],$pos[$hbond1[$i]],$facing[$hbond1[$i]];
      #printf STRONG "%d %d %d %d %d %d %d %d %d\n", $pairid, $res[$i],$aaid[$i],$pos[$i],$facing[$i],$res[$hbond1[$i]],$aaid[$hbond1[$i]],$pos[$hbond1[$i]],$facing[$hbond1[$i]];
      if ($strandc[$hbond1[$i]-1] ne $strand[$hbond1[$i]])
         {printf WEAK "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid,$aaid[$i], $pos[$i],$facing[$i], $aaid[$hbond1[$i]-1], $pos[$hbond1[$i]-1], $facing[$hbond1[$i]-1];}
    }
             

   if( (($bp1[$i] == 0)||($bp2[$i] == 0)) && ($aaid[$i] == 14) && ($strandc[$i]>0)&&(($strandc[$hbond2[$i]] == ($strandc[$i]+1)) || (($strandc[$i]== $strandnum) && ($strandc[$hbond2[$i]] == 1)))) # Pro-X strong H-bond
    { 
      $pairid = (10000*$prid + 100*$strandc[$i] + $strandc[$hbond2[$i]]);
      #printf STRONG "%d %d %d %d %d %d %d\n", $pairid,$aaid[$i],$pos[$i],$facing[$i], $aaid[$hbond2[$i]],$pos[$hbond2[$i]],$facing[$hbond2[$i]];
      #printf STRONG "%d %d %d %d %d %d %d %d %d\n", $pairid,$res[$i],$aaid[$i],$pos[$i],$facing[$i], $res[$hbond2[$i]],$aaid[$hbond2[$i]],$pos[$hbond2[$i]],$facing[$hbond2[$i]];

      if( $strandc[$hb2[$i]-1] == $strandc[$hbond2[$i]])
        { printf WEAK "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $pairid,$aaid[$i],$pos[$i],$facing[$i], $aaid[$hbond2[$i]-1],$pos[$hbond2[$i]-1],$facing[$hbond2[$i]-1];}
    }

}

sub aa_int 
{
    my $aa = $_[0];
    $aa=uc($aa);
    if( $aa eq  "A" )  { return 0; }
    if( $aa eq  "R" )  { return 1; }
    if( $aa eq  "N" )  { return 2; }
    if( $aa eq  "D" )  { return 3; }
    if( $aa eq  "C" )  { return 4; }
    if( $aa eq  "Q" )  { return 5; }
    if( $aa eq  "E" )  { return 6; }
    if( $aa eq  "G" )  { return 7; }
    if( $aa eq  "H" )  { return 8; }
    if( $aa eq  "I" )  { return 9; }
    if( $aa eq "L" )  { return 10; }
    if( $aa eq "K" )  { return 11; }
    if( $aa eq "M" )  { return 12; }
    if( $aa eq "F" )  { return 13; }
    if( $aa eq "P" )  { return 14; }
    if( $aa eq "S" )  { return 15; }
    if( $aa eq "T" )  { return 16; }
    if( $aa eq "W" )  { return 17; }
    if( $aa eq "Y" )  { return 18; }
    if( $aa eq "V" )  { return 19; }
    print "Invalid amino acid name $aa!\n";
    return 20;
}
