#!/usr/bin/env bash

# ============================================================
# file_system.sh
# ============================================================
# Practical Linux filesystem operations for bioinformatics
#
# Covers:
#   - Filesystem navigation
#   - Directory inspection
#   - File sizes and disk usage
#   - Finding genomic/data files
#   - Working with large sequencing datasets
#   - File permissions
#   - Symbolic links
#   - Compressed files
#   - Mount points / shared storage
#   - Checking logs and completed outputs
#   - Basic HPC filesystem inspection
# ============================================================


# ============================================================
# 1. WHERE AM I?
# ============================================================

# Print current working directory
pwd

# Resolve the absolute path
realpath .

# Show the current user's home directory
echo "$HOME"

# Move to home directory
cd "$HOME"

# Return to previous directory
cd -


# ============================================================
# 2. DIRECTORY INSPECTION
# ============================================================

# List files
ls

# Long listing
ls -lh

# Include hidden files
ls -lah

# Sort by modification time
ls -lht

# Sort by size
ls -lhS

# List only directories
find . -maxdepth 1 -type d

# List only files
find . -maxdepth 1 -type f


# ============================================================
# 3. CREATE A PROJECT STRUCTURE
# ============================================================

# Create nested directories
mkdir -p project/{data,results,logs,scripts}

# Create analysis-specific directories
mkdir -p project/results/{qc,alignment,variants}

# Verify structure
find project -maxdepth 3 -type d | sort


# ============================================================
# 4. FILE INFORMATION
# ============================================================

# Identify file type
file sample.fastq.gz

# Show file size
ls -lh sample.fastq.gz

# Show size in human-readable format
du -h sample.fastq.gz

# Show exact disk usage
du -sh sample.fastq.gz

# Show directory size
du -sh project/

# Show sizes of immediate subdirectories
du -h --max-depth=1 project/ | sort -h


# ============================================================
# 5. FIND LARGE BIOINFORMATICS FILES
# ============================================================

# Find FASTQ files
find data/ -type f \
    \( -name "*.fastq" -o -name "*.fq" \
       -o -name "*.fastq.gz" -o -name "*.fq.gz" \)

# Find BAM files
find data/ -type f \
    \( -name "*.bam" -o -name "*.bai" \)

# Find VCF files
find data/ -type f \
    \( -name "*.vcf" -o -name "*.vcf.gz" \
       -o -name "*.bcf" \)

# Find files larger than 10 GB
find data/ -type f -size +10G -ls

# Find files larger than 1 GB
find data/ -type f -size +1G -ls

# Find recently modified files
find data/ -type f -mtime -1

# Find files modified within the last 7 days
find data/ -type f -mtime -7


# ============================================================
# 6. FIND BY FILE NAME
# ============================================================

# Search recursively
find . -type f -name "*.bam"

# Case-insensitive search
find . -type f -iname "*.fastq.gz"

# Find files containing a particular sample identifier
find data/ -type f -name "*sample*"

# Find analysis logs
find . -type f \
    \( -name "*.log" -o -name "*.out" -o -name "*.err" \)


# ============================================================
# 7. COUNT FILES
# ============================================================

# Count FASTQ files
find data/ -type f -name "*.fastq.gz" | wc -l

# Count BAM files
find data/ -type f -name "*.bam" | wc -l

# Count VCF files
find results/ -type f -name "*.vcf.gz" | wc -l

# Count log files
find . -type f -name "*.log" | wc -l


# ============================================================
# 8. COPY / MOVE DATA
# ============================================================

# Copy a file
cp sample.fastq.gz backup/

# Copy while preserving attributes
cp -p sample.fastq.gz backup/

# Copy a directory recursively
cp -r results/ backup_results/

# Move a file
mv old_name.txt new_name.txt

# Move multiple files into a directory
mv *.log logs/


# ============================================================
# 9. SAFE FILE REMOVAL
# ============================================================

# Remove a file
rm temporary.txt

# Remove multiple temporary files
rm *.tmp

# Interactive removal
rm -i important_file.txt

# Remove an empty directory
rmdir empty_directory

# Recursive directory removal
# Use carefully.
rm -r temporary_directory


# ============================================================
# 10. SYMBOLIC LINKS
# ============================================================

# Create a symbolic link
ln -s /path/to/reference/reference.fa reference.fa

# Inspect symbolic links
ls -lh

# Find symbolic links
find . -type l -ls

# Resolve the target of a symbolic link
readlink -f reference.fa


# ============================================================
# 11. COMPRESSED GENOMIC DATA
# ============================================================

# Inspect compressed file without extracting it
zcat sample.fastq.gz | head

# Read the end of a compressed file
zcat sample.fastq.gz | tail

# Search inside compressed text
zgrep "^>" reference.fasta.gz

# Search FASTQ headers
zgrep "^@" sample.fastq.gz | head

# Decompress
gunzip sample.fastq.gz

# Compress
gzip sample.fastq

# Keep original while writing compressed output
gzip -c sample.fastq > sample.fastq.gz


# ============================================================
# 12. LARGE FILE HANDLING
# ============================================================

# Check whether a file is actually present
test -f sample.fastq.gz && echo "File exists"

# Check directory
test -d results && echo "Directory exists"

# Check whether a file is readable
test -r sample.fastq.gz && echo "Readable"

# Check whether a file is writable
test -w sample.fastq.gz && echo "Writable"

# Check whether a file is executable
test -x script.sh && echo "Executable"


# ============================================================
# 13. FILE PERMISSIONS
# ============================================================

# Inspect permissions
ls -l script.sh

# Make script executable
chmod +x script.sh

# Remove execute permission
chmod -x script.sh

# Add read permission for everyone
chmod a+r results.tsv

# Common script permission
chmod 755 script.sh

# Private file
chmod 600 sensitive_file.txt


# ============================================================
# 14. OWNERSHIP
# ============================================================

# Show ownership
ls -l sample.fastq.gz

# Show numeric UID/GID
ls -ln sample.fastq.gz

# Current user
whoami

# Current groups
groups


# ============================================================
# 15. CHECK DISK SPACE
# ============================================================

# Filesystem usage
df -h

# Filesystem type
df -Th

# Check a particular filesystem
df -h /path/to/data

# Inode usage
df -ih


# ============================================================
# 16. IDENTIFY STORAGE / MOUNT POINTS
# ============================================================

# Show mounted filesystems
mount

# More readable mounted filesystem information
findmnt

# Show filesystem types
findmnt -t nfs,nfs4

# Show disk/block devices
lsblk

# Display filesystem information
lsblk -f


# ============================================================
# 17. SHARED / NFS STORAGE
# ============================================================

# Identify NFS mounts
mount | grep -E 'nfs|nfs4'

# Or:
findmnt -t nfs,nfs4

# Check whether a shared mount is accessible
ls -ld /path/to/shared_storage

# Check available capacity
df -h /path/to/shared_storage

# Check filesystem type
df -Th /path/to/shared_storage


# ============================================================
# 18. CHECK DATA INTEGRITY / COMPLETENESS
# ============================================================

# Check file size
stat sample.bam

# Detailed file metadata
stat sample.fastq.gz

# Modification timestamp
stat -c '%y' sample.fastq.gz

# File checksum
md5sum sample.fastq.gz

# SHA256 checksum
sha256sum sample.fastq.gz

# Compare two files by checksum
md5sum file1 file2


# ============================================================
# 19. CHECK OUTPUTS FROM ANALYSIS JOBS
# ============================================================

# List logs
ls -lh logs/

# Find failed-looking logs
grep -iE "error|failed|fatal|exception" logs/*.log

# Check last lines of a log
tail -n 50 analysis.log

# Follow a running log
tail -f analysis.log

# Search for successful completion messages
grep -iE "complete|completed|finished|success" logs/*.log


# ============================================================
# 20. CHECK WHETHER EXPECTED OUTPUTS EXIST
# ============================================================

expected_files=(
    "results/sample.bam"
    "results/sample.bam.bai"
    "results/sample.vcf.gz"
    "results/sample.vcf.gz.tbi"
)

for file in "${expected_files[@]}"; do

    if [[ -f "$file" ]]; then
        echo "FOUND      $file"
    else
        echo "MISSING    $file"
    fi

done


# ============================================================
# 21. COMPARE INPUT / OUTPUT COUNTS
# ============================================================

input_count=$(find data/ -type f -name "*.fastq.gz" | wc -l)
output_count=$(find results/ -type f -name "*.bam" | wc -l)

echo "Input FASTQ files : $input_count"
echo "Output BAM files  : $output_count"


# ============================================================
# 22. FIND EMPTY FILES
# ============================================================

# Empty files
find . -type f -empty

# Empty BAM/VCF/log files
find results/ -type f -empty \
    \( -name "*.bam" -o -name "*.vcf*" -o -name "*.log" \)


# ============================================================
# 23. FIND RECENTLY GENERATED OUTPUT
# ============================================================

# Files modified today
find results/ -type f -daystart -mtime 0

# Files modified within the last hour
find results/ -type f -mmin -60

# Sort files by modification time
find results/ -type f -printf '%T@ %p\n' |
    sort -nr |
    cut -d' ' -f2- |
    head


# ============================================================
# 24. FILESYSTEM SUMMARY
# ============================================================

echo "=========================================="
echo "Filesystem summary"
echo "=========================================="

echo "Working directory:"
pwd

echo
echo "User:"
whoami

echo
echo "Disk usage:"
df -h .

echo
echo "Project size:"
du -sh project/ 2>/dev/null

echo
echo "FASTQ files:"
find data/ -type f \
    \( -name "*.fastq" -o -name "*.fastq.gz" \) |
    wc -l

echo
echo "BAM files:"
find results/ -type f -name "*.bam" |
    wc -l

echo
echo "VCF files:"
find results/ -type f \
    \( -name "*.vcf" -o -name "*.vcf.gz" \) |
    wc -l

echo
echo "=========================================="
