$pdb = shift @ARGV;
open(IN, "<$pdb.coord");
open(OUT, ">strands/$pdb.strands");
$flag = 0;

while(<IN>)
{
	@arr = split(' ',$_);
	if($flag == 0)
	{
		if(($arr[7] eq "1" || $arr[7] eq "2") && $arr[8] eq "1")
		{
			$flag = 1;
			printf OUT aa_char($arr[2]);
		}
	}
	else
	{
		if(($arr[7] eq "1" || $arr[7] eq "2") && $arr[8] eq "1")
		{
			printf OUT aa_char($arr[2]);
		}
		else
		{
			$flag = 0;
			printf OUT "\n";
		}
	}
}
close(IN);
close(OUT);
sub aa_char 
{
    my $aa = $_[0];
    if( $aa ==  0 )  { return "A"; }
    if( $aa ==  1 )  { return "R"; }
    if( $aa ==  2 )  { return "N"; }
    if( $aa ==  3 )  { return "D"; }
    if( $aa ==  4 )  { return "C"; }
    if( $aa ==  5 )  { return "Q"; }
    if( $aa ==  6 )  { return "E"; }
    if( $aa ==  7 )  { return "G"; }
    if( $aa ==  8 )  { return "H"; }
    if( $aa ==  9 )  { return "I"; }
    if( $aa == 10 )  { return "L"; }
    if( $aa == 11 )  { return "K"; }
    if( $aa == 12 )  { return "M"; }
    if( $aa == 13 )  { return "F"; }
    if( $aa == 14 )  { return "P"; }
    if( $aa == 15 )  { return "S"; }
    if( $aa == 16 )  { return "T"; }
    if( $aa == 17 )  { return "W"; }
    if( $aa == 18 )  { return "Y"; }
    if( $aa == 19 )  { return "V"; }
    return "X";
}
