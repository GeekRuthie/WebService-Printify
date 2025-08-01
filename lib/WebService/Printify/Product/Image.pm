use v5.38;
use feature 'class';
no warnings qw/experimental::class/;

class WebService::Printify::Product::Image {
   field $product :param;

   field $src :param :reader;
   field $is_selected_for_publishing :param :reader;
   field $variant_ids :param;
   field $is_default :param :reader;
   field $position :param :reader;
   field $order :param :reader;

   field @variant_ids :reader;

   ADJUST {
      foreach my $v (@$variant_ids) {
         push @variant_ids, $v;
      }
   }



}