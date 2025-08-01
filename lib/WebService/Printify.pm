use v5.38;
use feature 'class';
no warnings qw/experimental::class/;
# VERSION
# AUTHORITY
# ABSTRACT: Connect to the Printify API
use HTTP::Request;
use JSON::XS qw/decode_json/;
use LWP::UserAgent ();
use MIME::Base64;
use WebService::Printify::Product;
use WebService::Printify::Product::Image;
use WebService::Printify::Product::Option;
use WebService::Printify::Product::Option::Value;
use WebService::Printify::Product::Variant;
use WebService::Printify::Shop;

class WebService::Printify {

   field $specific_store :param = undef;
   field $token          :param;

   field @shops;
   
   # We're going to handle all the talking back and forth, not our children.
   my $base_url = 'https://api.printify.com/v1';
   my $ua = LWP::UserAgent->new( timeout => 10 );

   method shops {
      if (!scalar @shops) {
         my $result = $self->&api_get('shops');
         die "$result->{error_code}" if !$result->{ok};
         foreach my $shop (@{$result->{data}}){
            next if $specific_store && $shop->{id} != $specific_store;
            push @shops, WebService::Printify::Shop->new( %$shop, ws => $self );
         }
      }
      return wantarray ? @shops : scalar @shops;
   }

   #
   # Everything below here should probably be in a role. But 
   # there isn't any such animal yet.  Soon, baby, soon...
   #
   # ..or maybe a class of its own, that all the bits pass around and
   # share?
   #

   method api_get ($uri, $page = undef ) {
      my $header = ['User-Agent'    => 'WebService::Printify',
                    'Content-Type'  => 'application/json; charset=UTF-8',
                    'Authorization' => "Bearer $token" ];
      my $final_uri = "$base_url/$uri.json?limit=2";
      if ($page) {
         $final_uri .= "&page=$page";
      }
      my $req = HTTP::Request->new('GET', $final_uri, $header);
      my $response   = $ua->request($req);
      my $result     = JSON::XS::decode_json( $response->decoded_content );
      my $ok = 1;
      my $error_code;
      if ( !$response->is_success ) {
         warn "Unable to call $uri: " . $response->status_line;
         $ok = 0;
         $error_code = $response->status_line;
      }
      return {
         ok         => $ok,
         error_code => $error_code,
         data       => $result,
      };
   }
}

__END__

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head1 ATTRIBUTES

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=over 4

=item Pagination

The default pagination for APIs that are paginated is 10.  There isn't a 
way at present for you to change ffrom that.  The module will, however, 
parse out multiple pages and import all the objects properly (i.e. on the 
C<product> API, if you ask for the products method, the system will populate the shop
with all available products for you; you don't need to worry about paging through
the results!)

=back

=head1 ACKNOWLEDGEMENTS

I started working on this code on my trip to the memorial service for 
L<Matt S Trout (mst)|https://metacpan.org/author/MSTROUT>. Matt was my first
solid connection to the Perl community, and in our years of interactions, he
constantly encouraged me to grow and learn new things. 

This is my first use of the new L<class|https://perldoc.perl.org/perlclass> 
feature, and a chance for me to experiment and learn how to use it.

This module is therefore dedicated to the memory of my dear, complicated
friend, Matt S Trout.

=head1 SEE ALSO

=cut
