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
  DESCRIPTION => 'Check the variation database does not contain duplicated Publication entries',
  DB_TYPES    => ['variation'],
  TABLES      => ['publication']
};

sub tests {
  my ($self) = @_;

  $self->checkTitle('Variation publication title', 'Variation publications have no title'); 

  my $desc = 'Variation publication duplicated pmid, pmcid, doi'; 
  # my $diag = 'Variation publications have duplicated rows'; 

  $self->checkDuplicated('pmid', $desc); 
  $self->checkDuplicated('pmcid', $desc); 
  $self->checkDuplicated('doi', $desc); 

  $self->checkDisplay('variation', 'Variation cited variants display', 'Variation cited variants have variation.display = 0'); 
  $self->checkDisplay('variation_feature', 'Variation cited variants display', 'Variation cited variants have variation_feature.display = 0');  

}

sub checkTitle {
  my ($self, $desc, $diag) = @_; 

  my $sql_title = qq/
      SELECT *
      FROM publication
      WHERE title IS NULL
      or title = 'NULL'
      or title = '' 
  /;
  is_rows_zero($self->dba, $sql_title, $desc, $diag); 
  
}

sub checkValues {
  my ($self, $desc, $diag) = @_;

  my $sql_values = qq/
      SELECT *
      FROM publication
      WHERE pmid IS NULL
      and pmcid IS NULL
      and doi IS NULL
  /;
  is_rows_zero($self->dba, $sql_values, $desc, $diag);

}

sub checkDuplicated {
  my ($self, $id, $desc) = @_; 
  
  my $sql_stmt = qq/
      SELECT *
      FROM publication p1, publication p2 
      WHERE p1.$id = p2.$id  
      and p1.publication_id < p2.publication_id 
  /;
  is_rows_zero($self->dba, $sql_stmt, $desc, 'Variation publications are duplicated on '. $id);  
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
