#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use JSON qw(decode_json);
use threads;

# Base URL for The Cat API
my $BASE_URL = 'https://api.thecatapi.com/v1';

# Function to make API requests
sub fetch_data {
    my ($endpoint) = @_;
    my $ua         = LWP::UserAgent->new;
    my $url        = "$BASE_URL/$endpoint";
    my $response   = $ua->get($url);

    if ($response->is_success) {
        return decode_json($response->decoded_content);
    } else {
        die "Failed to fetch $endpoint: " . $response->status_line;
    }
}

# Function to fetch and display random cat images
sub fetch_images {
    my $data = fetch_data("images/search?limit=3");
    print "\nRandom Cat Images:\n";
    foreach my $i (0 .. $#{$data}) {
        print ($i + 1) . ". $data->[$i]->{url}\n";
    }
}

# Function to fetch and display cat breeds
sub fetch_breeds {
    my $data = fetch_data("breeds");
    print "\nCat Breeds:\n";
    foreach my $i (0 .. 4) {    # Display the first 5 breeds
        print ($i + 1) . ". $data->[$i]->{name} - Origin: $data->[$i]->{origin}\n";
    }
}

# Function to fetch and display categories
sub fetch_categories {
    my $data = fetch_data("categories");
    print "\nCategories:\n";
    foreach my $i (0 .. $#{$data}) {
        print ($i + 1) . ". $data->[$i]->{name}\n";
    }
}

# Main function to run tasks concurrently
sub main {
    print "Fetching data from The Cat API...\n";

    # Create threads for concurrent tasks
    my $images_thread    = threads->create(\&fetch_images);
    my $breeds_thread    = threads->create(\&fetch_breeds);
    my $categories_thread = threads->create(\&fetch_categories);

    # Wait for threads to complete
    $images_thread->join();
    $breeds_thread->join();
    $categories_thread->join();

    print "\nAll data fetched successfully!\n";
}

# Run the main function
main();
