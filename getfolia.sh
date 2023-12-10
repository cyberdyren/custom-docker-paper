
echo "Downloading Folia..."
git clone https://github.com/PaperMC/Folia.git

echo "Changing directory to Folia..."
cd Folia

echo "Making gradlew executable..."
chmod +x gradlew

echo "Downloading patches..."
./gradlew applyPatches

echo "Building..."
./gradlew createReobfPaperclipJar


# Find the file matching the pattern
file=$(find ./build/libs -type f -name 'folia-bundler-*-reobf.jar' -print -quit)

# If the file exists, rename it
if [ -f "$file" ]; then
    mv "$file" ./folia.jar
    echo "File renamed to folia.jar"
else
    echo "No file matching the pattern found"
fi


echo ";)"