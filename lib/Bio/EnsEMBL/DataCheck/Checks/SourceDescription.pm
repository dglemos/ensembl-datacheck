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

package Bio::EnsEMBL::DataCheck::Checks::SourceDescription;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck; 

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'SourceDescription',
  DESCRIPTION => 'Source table is consistent',
  DB_TYPES    => ['variation'],
  TABLES      => ['source']
};

sub tests {
  my ($self) = @_;

  is_value_null($self->dba, 'source', 'description', 'Source description missing', 'Source has no description');

  my $desc_desc = 'Source description length';
  my $diag_desc = 'Sources have long descriptions'; 
  my $sql_desc = qq/
      SELECT *
      FROM source
      WHERE length(description) > 100 
      and data_types = 'variation'
  /;
  is_rows_zero($self->dba, $sql_desc, $desc_desc, $diag_desc);

  my $desc_version = 'Different versions set for dbSNP sources'; 
  my $sql_version = qq/
      SELECT DISTINCT version 
      FROM source
      WHERE name like '%dbSNP%'
  /; 
  cmp_rows($self->dba, $sql_version, '<=', 1, $desc_version);  

}

1;

