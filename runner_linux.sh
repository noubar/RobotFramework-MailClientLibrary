cleanup () {
  rm -rf build
  rm -rf dist
  rm -rf keywords
  rm -rf src/robotframework_BehaviorTreeLibrary.egg-info
}

dependency () {
  python3 -m pip3 install --upgrade pip3 setuptools wheel
  pip3 install -r requirements-dev.txt
}

build () {
  cleanup
  dependency
  python3 setup.py sdist bdist_wheel
  python3 libdoc.py
}

install () {
  build
  pip3 install .
}

test_robot () {
  cd atests || exit
  robot -i unit --outputdir ../result/ .
  cd ..
}

test () {
  install
  result=$?
  mkdir result
  test_robot
  if [ $result -eq 0 ]; then
    result=$?
  fi
  cleanup
  exit $result
}

if [ ! -z "$1" ]; then
  $1
fi
