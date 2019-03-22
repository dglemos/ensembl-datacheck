=head1 LICENSE

Copyright [2018-2019] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the 'License');
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an 'AS IS' BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package Bio::EnsEMBL::DataCheck::Checks::VariationSubset;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'VariationSubset',
  DESCRIPTION => 'Variation set is not a subset of itself',
  GROUPS      => ['variation_import'], 
  DB_TYPES    => ['variation'],
  TABLES      => ['variation_set','variation_set_structure']
};

sub tests {
  my ($self) = @_;

  my $desc = 'Variation set is not a subset of itself';
  my $diag = 'Variation set is a subset of itself';
  my $sql = q/
      SELECT DISTINCT v.name
      FROM  variation_set v
      JOIN variation_set_structure vs
      ON (vs.variation_set_sub = vs.variation_set_super
      AND v.variation_set_id = vs.variation_set_super); 
  /;
  my $result = is_rows_zero($self->dba, $sql, $desc, $diag);

  if($result = 1){
    
    my $desc = '';

  }

}

1;

