# React Native Steps App


React Native step counter for iOS and Android. 

* iOS uses the HealthKit API.
* Android uses the Google Fit API.

# Build

* Install both watchman and node using Brew
    - brew install node
    - brew install watchman 
* Install React Native CLI 
    ```{r, engine='bash', count_lines}
    npm install -g react-native-cli
    ```
* Clone and run project packager.
    ```{r, engine='bash', count_lines}
    git clone https://github.com/StasDoskalenko/React-Native-Steps-App.git react-native-steps-app
    cd react-native-steps-app
    npm start
    ```
* Open another terminal window (don't close packager terminal). And run project at device
    (Xcode >= 8 required)
    ```{r, engine='bash', count_lines}
    react-native run-ios --configuration Release
    ```
* In some cases try to build directly via Xcode

##  Built with :

* [react-native](https://github.com/facebook/react-native)
* [react-native-circular-progress](https://github.com/bgryszko/react-native-circular-progress)
* [react-native-linear-gradient](https://github.com/brentvatne/react-native-linear-gradient)
* [react-native-router-flux](https://github.com/aksonov/react-native-router-flux)
* [react-native-vector-icons](https://github.com/oblador/react-native-vector-icons)
* [react-redux](https://github.com/reactjs/react-redux)



<img src="./images/ios-app-screenshot.png" width=400>

## Licence
Based on Asim Malik AwesimSteps app