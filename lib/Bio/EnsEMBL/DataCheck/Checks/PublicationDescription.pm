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

package Bio::EnsEMBL::DataCheck::Checks::PublicationDescription;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'PublicationDescription',
  DESCRIPTION => 'Publications cited variants display',
  DB_TYPES    => ['variation'],
  TABLES      => ['publication']
};

sub tests {
  my ($self) = @_;

  $self->checkDisplay('variation', 'Variation cited variants display', 'Variation cited variants have variation.display = 0'); 
  $self->checkDisplay('variation_feature', 'Variation cited variants display', 'Variation cited variants have variation_feature.display = 0'); 

}

sub checkDisplay {
  my ($self, $input, $desc, $diag) = @_; 
  
  my $sql_stmt = qq/
      SELECT *
      FROM $input,variation_citation 
      WHERE $input.variation_id = variation_citation.variation_id  
      and $input.display=0 
  /;
  is_rows_zero($self->dba, $sql_stmt, $desc, $diag); 
}

1;

