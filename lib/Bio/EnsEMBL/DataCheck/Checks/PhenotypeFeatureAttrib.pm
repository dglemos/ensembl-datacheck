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

package Bio::EnsEMBL::DataCheck::Checks::PhenotypeFeatureAttrib;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'PhenotypeFeatureAttrib',
  DESCRIPTION => 'Checks that imported Variation phenotype_feature_attrib values are reasonable',
  DB_TYPES    => ['variation'],
  TABLES      => ['phenotype_feature_attrib']
};

sub tests {
  my ($self) = @_;

  my $non_terms = "( \"None\", \"not specified\", \"Not in OMIM\", \"Variant of unknown significance\", \"?\", \".\" )";
  is_non_term($self->dba, 'phenotype_feature_attrib', 'value', $non_terms, 'Meaningful phenotype_feature_attrib attribute value', 'phenotype_feature_attrib attribute value is not useful'); 

  unsupported_char($self->dba, 'phenotype_feature_attrib', 'value', 'ASCII chars printable in phenotype_feature_attrib attribute value', 'phenotype_feature_attrib attribute value has unsupported ASCII chars'); 

}

1;

