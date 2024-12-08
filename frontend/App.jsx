import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { StyleSheet, Text, View } from 'react-native';
import LoginScreen from './src/screen/loginScreen';
import SignupScreen from './src/screen/signupScreen';
import LoadingScreen from './src/screen/loadingScreen';

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="Login" component={LoginScreen}/>
        <Stack.Screen name="Signup" component={SignupScreen}/>
        <Stack.Screen name="Loading" component={LoadingScreen}/>
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default App;

const styles = StyleSheet.create({});
