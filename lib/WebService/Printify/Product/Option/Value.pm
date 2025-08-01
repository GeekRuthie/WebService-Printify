use v5.38;
use feature 'class';
no warnings qw/experimental::class/;

class WebService::Printify::Product::Option::Value {
   field $option  :param;
   field $id      :param :reader;
   field $title   :param :reader;
   field $colors  :param = undef;

   field @colors  :reader;

   ADJUST {
      if ($colors) {
         foreach my $c (@$colors) {
            push @colors, $c;
         }
      }
   }




}