use v5.38;
use feature 'class';
no warnings qw/experimental::class/;

class WebService::Printify::Shop {
   field $ws            :param;
   field $id            :param :reader;

   field $sales_channel :param :reader;         
   field $title         :param :reader;

   field @products;

   method products {
      if (!scalar @products) {
         my $page = 1;
         while (1) {
            my $result = $ws->api_get("shops/$id/products", $page);
            foreach my $p (@{$result->{data}->{data}}) {
               push @products, WebService::Printify::Product->new( %$p, ws => $ws, shop => $self );
            }
            last if $result->{data}->{current_page} == $result->{data}->{last_page};
            $page++;
         }
      }
      return wantarray ? @products : scalar @products;

   }
}
