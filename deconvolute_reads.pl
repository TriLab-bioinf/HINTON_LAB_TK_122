#!/usr/local/bin/perl
use strict;

# Command
# ./deconvolute_reads.pl -s SampleSheet.csv -f Undetermined_S0_L002_R1_001.fastq.gz

#[Data]
#FCID,Lane,SampleID,SampleRef,Index,Description,Control,Recipe,Operator,Project,index2,
#A00941,1,JK-9534_2_1,NC_002929.2,AATAATGT,B._pertussis_WT_-Mg,N,single_end_100bp,HAL,TK_122,


# get parameters
my $usage = "$0 -s <SampleSheet.csv> -f <fastq file> [-o output_dir def=OUTPUT]\n\n";
my %arg = @ARGV;
die $usage unless $arg{-s} && $arg{-f};

my $outdir = $arg{-o} || 'OUTPUT';

# Load barcode data
open (my $bc, "<$arg{-s}") || die "ERROR, I cannot open $arg{-s}: $!\n\n";
my %idx;
while(<$bc>){
    chomp;
    my (undef,undef,$sample_id,undef,$idx,undef,undef,undef,undef,undef,undef,undef) = split(m/,/,$_);
    $idx{$idx} = $sample_id if $idx; # do not include empty strings
}
close $bc;

# foreach my $k (keys %idx){
#     print "$k :: $idx{$k}\n";
# }

`mkdir -p $outdir`;

open (my $fastq, "/usr/bin/gunzip -c $arg{-f} |") || die "ERROR, I cannot open $arg{-f}: $!\n\n";
my $counter;
my $top = 10;
while(<$fastq>){
    chomp;
    
    # get sequence data
    my $id = $_;
    my $seq = <$fastq>;
    my $plus = <$fastq>;
    my $qual = <$fastq>;

    my ($i, $s) = ($1, $2) if $seq =~ m/^(.{8})(.+)$/;
    my ($qi, $qs) = ($1, $2) if $qual =~ m/^(.{8})(.+)$/;

    if ($idx{$i}){
        # $counter++;
        my $file = $idx{$i}.".fastq";
        #print "id=$id >> seq=$seq >> barcode=$i >> new_seq=$s >> $idx{$i}\n";

        open (OUT, ">>./OUTPUT/$file");
        print OUT "$id\n$s\n+\n$qs\n";
        close $file;
    }
    
    # last if $counter >= 10;
}
close $fastq;


