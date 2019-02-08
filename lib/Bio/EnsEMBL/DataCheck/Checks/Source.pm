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

package Bio::EnsEMBL::DataCheck::Checks::Source;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck; 

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'Source',
  DESCRIPTION => 'Checks that the variation source table is consistent',
  DB_TYPES    => ['variation'],
  TABLES      => ['source']
};

sub tests {
  my ($self) = @_;

  my $desc_version = 'Different versions set for dbSNP sources'; 
  my $sql_version = qq/
      SELECT COUNT(DISTINCT version)
      FROM source
      WHERE name like '%dbSNP%'
  /; 
  cmp_rows($self->dba, $sql_version, '<=', 1, $desc_version); 

  my $desc_missing = 'Variation source description';
  my $diag_missing = 'Variation source description is missing'; 
  my $sql_desc = qq/
      SELECT COUNT(*)
      FROM source
      WHERE description IS NULL
      or description = 'NULL'
  /;
  is_rows_zero($self->dba, $sql_desc, $desc_missing, $diag_missing); 

  my $desc_length = 'Variation source description length';
  my $diag_length = 'Variation sources have long descriptions'; 
  my $sql_length = qq/
      SELECT COUNT(*)
      FROM source
      WHERE length(description) > 100 
      and data_types = 'variation'
  /;
  is_rows_zero($self->dba, $sql_length, $desc_length, $diag_length); 

  my $desc_url = 'Variation source URL';
  my $diag_url = 'Variation source URL is missing'; 
  my $sql_url = qq/
      SELECT COUNT(*)
      FROM source
      WHERE url IS NULL
      or url = 'NULL'
  /;
  is_rows_zero($self->dba, $sql_url, $desc_url, $diag_url);  

}

1;

