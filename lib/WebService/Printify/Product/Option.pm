use v5.38;
use feature 'class';
no warnings qw/experimental::class/;

class WebService::Printify::Product::Option {
   field $product            :param;
   field $name               :param :reader;

   field $display_in_preview :param :reader;
   field $type               :param :reader;
   
   field $values             :param;
   
   field @values             :reader;

   ADJUST {
      foreach my $v (@$values) {
         push @values, WebService::Printify::Product::Option::Value->new( %$v, option => $self );
      }
   }
}