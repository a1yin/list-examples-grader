CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
rm -rf student-submission
rm -rf grading-area
mkdir grading-area
git clone $1 student-submission
echo 'Finished cloning'

if [ -f "student-submission/ListExamples.java" ]; then
    echo "File Found"
else
    echo "File ListExamples.java not found"
    exit 1
fi

cp student-submission/ListExamples.java grading-area/
cp TestListExamples.java grading-area/
cp -r lib grading-area

cd grading-area

javac -cp ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar" *.java

if [ $? -ne 0 ]; then
    echo "Compilation error!"
    exit 1
fi
echo "Program compiled sucessfully"
# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > output.txt

passed_tests=$(grep -o 'OK' "output.txt" | wc -l)

if [ $passed_tests -ne 0 ]; then
    echo "All Tests Passed!"
    echo "Score: 100"
else
    failures=$(grep -o 'Failures: [0-9]*' "output.txt" | awk '{print $2}')
    tests_run=$(grep -o 'Tests run: [0-9]*' "output.txt" | awk '{print $3}') 
    echo "Number of tests run: $tests_run"
    echo "Number of failures: $failures"
    
    score=$(awk "BEGIN { printf \"%.2f\", ($tests_run - $failures) / $tests_run * 100}")
    echo "Score: $score"
fi