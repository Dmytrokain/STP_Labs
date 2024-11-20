#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;

# URL of the dataset
my $csv_url = "https://raw.githubusercontent.com/Krista07/datasets/main/Cats.csv";
my $csv_file = "Cats.csv";

# Download the CSV file if it doesn't exist locally
if (!-e $csv_file) {
    print "Downloading dataset...\n";
    system("curl -o $csv_file $csv_url") == 0 or die "Failed to download dataset: $!";
}

# Open the CSV file
open(my $fh, '<', $csv_file) or die "Cannot open file '$csv_file': $!";

# Initialize CSV parser
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

# Read the header row
my $header = $csv->getline($fh);

# Prepare data structures for analysis
my %breeds_by_origin;
my %coat_type_count;
my %patterns;

# Process each row in the CSV
while (my $row = $csv->getline($fh)) {
    my ($breed, $origin, $body_type, $coat_type, $pattern) = @$row;

    # Count breeds by origin
    $breeds_by_origin{$origin}++;

    # Count breeds by coat type
    $coat_type_count{$coat_type}++;

    # Track unique coat patterns
    $patterns{$pattern} = 1;

    # Example of pattern matching: Find breeds with specific keywords in their name
    if ($breed =~ /Maine|Persian|Siamese/) {
        print "Special Breed Match: $breed (Origin: $origin, Coat Type: $coat_type, Pattern: $pattern)\n";
    }
}

close($fh);

# Print analysis results
print "\n=== Cat Breeds by Origin ===\n";
foreach my $origin (sort keys %breeds_by_origin) {
    printf "%-20s: %d breeds\n", $origin, $breeds_by_origin{$origin};
}

print "\n=== Cat Breeds by Coat Type ===\n";
foreach my $coat_type (sort keys %coat_type_count) {
    printf "%-20s: %d breeds\n", $coat_type, $coat_type_count{$coat_type};
}

print "\n=== Unique Coat Patterns ===\n";
foreach my $pattern (sort keys %patterns) {
    print "- $pattern\n";
}
