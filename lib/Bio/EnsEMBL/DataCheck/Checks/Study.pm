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

package Bio::EnsEMBL::DataCheck::Checks::Study;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'Study',
  DESCRIPTION => 'Check that Variation Study values are reasonable',
  DB_TYPES    => ['variation'],
  TABLES      => ['study']
};

sub tests {
  my ($self) = @_;

  my $desc = 'Variation Study source_id'; 
  my $diag = 'Variation Study source_id = 0'; 
  my $sql = qq/
      SELECT *
      FROM study
      WHERE source_id = 0
  /;
  is_rows_zero($self->dba, $sql, $desc, $diag); 
}

1;

