use v5.38;
use feature 'class';
no warnings qw/experimental::class/;
use JSON::XS qw/encode_json/;

class WebService::Printify::Product {
   field $ws   :param;
   field $shop :param;
   field $id   :param :reader;

   field $blueprint_id                 :param :reader;
   field $created_at                   :param :reader;
   field $description                  :param :reader;
   field $is_deleted                   :param :reader;
   field $is_economy_shipping_eligible :param :reader;
   field $is_economy_shipping_enabled  :param :reader;
   field $is_locked                    :param :reader;
   field $is_printify_express_eligible :param :reader;
   field $is_printify_express_enabled  :param :reader;
   field $original_product_id          :param :reader;
   field $print_provider_id            :param :reader;
   field $shop_id                      :param :reader;
   field $title                        :param :reader;
   field $updated_at                   :param :reader;
   field $user_id                      :param :reader;
   field $visible                      :param :reader;

   # TODO Some of these are more-or-less complex structurs 
   # we're not using yet.

   field $images                    :param;
   field $options                   :param;
   field $print_areas               :param;  # TODO
   field $print_details             :param;  # TODO
   field $sales_channel_properties  :param;  # TODO
   field $tags                      :param;
   field $variants                  :param;
   field $views                     :param;  # TODO

   field @images                    :reader;
   field @tags                      :reader;
   field @options                   :reader;
   field @variants                  :reader;

   ADJUST {
      # The structures need to be parsed; some are objects themselves.
      foreach my $i (@$images) {
         use Data::Dumper; warn Dumper($i);
         push @images, WebService::Printify::Product::Image->new( %$i, product => $self );
      }
      foreach my $o (@$options) {
         push @options, WebService::Printify::Product::Option->new( %$o, product => $self );  
      }
      foreach my $t (@$tags) {
         push @tags, $t;
      }
      foreach my $v (@$variants) {
         push @variants, WebService::Printify::Product::Variant->new( %$v, product => $self );
      }
   }

   method TO_JSON () {
      foreach my $i (@images) {
            use Data::Dumper; warn $i->src; warn $i->order; 
         }

      return JSON::XS::encode_json({
         id => $self->id,
      });
   }
}