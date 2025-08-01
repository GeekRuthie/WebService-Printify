use v5.38;
use feature 'class';
no warnings qw/experimental::class/;

class WebService::Printify::Product::Variant {
   field $product            :param;
   field $id:param :reader;
   field $grams:param :reader;
   field $is_default:param :reader;
   field $sku:param :reader;
   field $is_available:param :reader;
   field $is_printify_express_eligible:param :reader;
   field $cost:param :reader;
   field $price:param :reader;
   field $quantity:param :reader;
   field $title:param :reader;
   field $options:param :reader;
   field $is_enabled :param :reader;

}