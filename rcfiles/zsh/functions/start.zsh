start() {
  if [ -f $PWD/package.json ]; then
    echo "NPM package identified..."
    npm start || npm run dev
  fi
}