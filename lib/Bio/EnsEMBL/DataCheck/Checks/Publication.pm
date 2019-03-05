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

package Bio::EnsEMBL::DataCheck::Checks::Publication;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'Publication',
  DESCRIPTION => 'There are no duplicated Publication entries',
  GROUPS      => ['variation'],
  DB_TYPES    => ['variation'],
  TABLES      => ['publication']
};

sub tests {
  my ($self) = @_;

  is_missing_value($self->dba, 'publication', 'title', 'Publication title missing', 'Publication with no title'); 

  $self->checkValues('Publication id values', 'Publication with no pmid, pmcid and doi');

  my $desc = 'Publication duplicated pmid, pmcid, doi'; 
  duplicated_rows($self->dba, 'publication', 'pmid', 'publication_id', $desc, 'Publication is duplicated on pmid');   
  duplicated_rows($self->dba, 'publication', 'pmcid', 'publication_id', $desc, 'Publication is duplicated on pmcid');
  duplicated_rows($self->dba, 'publication', 'doi', 'publication_id', $desc, 'Publication is duplicated on doi');

}

sub checkValues {
  my ($self, $desc, $diag) = @_;

  my $sql_values = qq/
      SELECT *
      FROM publication
      WHERE pmid IS NULL
      AND pmcid IS NULL
      AND doi IS NULL
  /;
  is_rows_zero($self->dba, $sql_values, $desc, $diag);
} 

1;

