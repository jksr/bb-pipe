$pdb = shift @ARGV;
open(IN, "<temp/$pdb.coord");
open(OUT, ">temp/$pdb.strand.coords");
$i = 0;
$flag = 0;

while(<IN>)
{
	@arr = split(' ',$_);
	if($flag == 0)
	{
		if(($arr[7] eq "1" || $arr[7] eq "2") && $arr[8] eq "1")
		{
			$flag = 1;
			$i++;
			printf OUT "%d %d %d %d %d %d\n",$arr[0],$i,$arr[1],$arr[2],$arr[6],$arr[7];
		}
		else
		{
			printf OUT "%d %d %d %d %d %d\n",$arr[0],0,$arr[1],$arr[2],$arr[6],$arr[7];
		}
	}
	else
	{
		if(($arr[7] eq "1" || $arr[7] eq "2") && $arr[8] eq "1")
		{
			printf OUT "%d %d %d %d %d %d\n",$arr[0],$i,$arr[1],$arr[2],$arr[6],$arr[7];
		}
		else
		{
			$flag = 0;
			printf OUT "%d %d %d %d %d %d\n",$arr[0],0,$arr[1],$arr[2],$arr[6],$arr[7];
		}
	}

	
}
close(IN);
close(OUT);
