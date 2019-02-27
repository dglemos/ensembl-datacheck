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

package Bio::EnsEMBL::DataCheck::Checks::PhenotypeDescription;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'PhenotypeDescription',
  DESCRIPTION => 'Check that imported description contains only supported characters',
  DB_TYPES    => ['variation'],
  TABLES      => ['phenotype']
};

sub tests {
  my ($self) = @_;


  my $desc_length = 'Phenotype description length';
  my $diag_length = 'Phenotype with suspiciously short description';
  my $sql_length = qq/
      SELECT *
      FROM phenotype
      WHERE description IS NOT NULL
      AND LENGTH(description) < 4
  /;
  is_rows_zero($self->dba, $sql_length, $desc_length, $diag_length);

  my $desc_newline = 'Phenotype description with new line';
  my $diag_newline = 'Phenotype with unsupported new line in description'; 
  my $sql_newline = qq/
      SELECT *
      FROM phenotype
      WHERE description IS NOT NULL
      AND description LIKE '%\n%'
  /;
  is_rows_zero($self->dba, $sql_newline, $desc_newline, $diag_newline);
  
  unsupported_char($self->dba, 'phenotype', 'description', 'ASCII chars printable in phenotype description', 'Phenotype description with unsupported ASCII chars'); 

  my $non_terms = "( \"None\", \"Not provided\", \"not specified\", \"Not in OMIM\", \"Variant of unknown significance\", \"not_provided\", \"?\", \".\" )";
  is_non_term($self->dba, 'phenotype', 'description', $non_terms, 'Meaningful phenotype description', 'Phenotype description is not useful'); 
}

1;
