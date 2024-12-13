import React, {useContext} from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { StyleSheet, View, ActivityIndicator } from 'react-native';
import LoginScreen from './src/screen/loginScreen';
import SignupScreen from './src/screen/signupScreen';
import LoadingScreen from './src/screen/loadingScreen';
import { AuthContext, AuthProvider } from './src/context/AuthContext';

const Stack = createNativeStackNavigator();

const App = () => {

//   const {isLoading, userToken} = useContext(AuthContext);
// if ( isLoading) {
//     <View style={{flex : 1, justifyContent: 'center', alignItems: 'center'}}>
//       <ActivityIndicator size={'large'} />
//     </View>;
// }

  return (
    <AuthProvider>
      <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="Login" component={LoginScreen}/>
        <Stack.Screen name="Signup" component={SignupScreen}/>
        <Stack.Screen name="Loading" component={LoadingScreen}/>
      </Stack.Navigator>
    </NavigationContainer>
    </AuthProvider>
  );
};

export default App;

