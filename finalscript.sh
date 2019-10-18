#Kyle Sommerfield and Farai Musariri

#Combine hsp files into one
cat hsp*.fasta > combinedhsp.fasta
#Combine mcrA files into one
cat mcrA*.fasta > combinedmcrA.fasta

#Use muscle to align hsp
./muscle -in combinedhsp.fasta -out combinedhsp.afa
#Use muscle to align mcrA
./muscle -in combinedmcrA.fasta -out combinedmcrA.afa

#Build hidden Markov model for hsp
./hmmbuild combinedhsp.hmm combinedhsp.afa
#Build hidden Markov model for mcrA
./hmmbuild combinedmcrA.hmm combinedmcrA.afa

#Use hmm to search proteomes for hsp and mcrA
For N in {01..50}
do
./hmmsearch --tblout $hspsearch_$N.out combinedhsp.hmm proteome_$N.fasta
./hmmsearch --tblout $mcrAsearch_$N.out combinedmcrA.hmm proteome_$N.fasta
done

#Create table of proteome, mcrA, and hsp
For N in {01..50}
do
x=$(cat hspsearch_$N.out | grep -v "#" | wc -l)
y=$(cat mcrAsearch_$N.out | grep -v "#" | wc -l)
echo "$N,$y,$x" > finaltable.txt

