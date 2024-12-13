/* eslint-disable react-native/no-inline-styles */
import React, {useContext, useState} from 'react';
import { StyleSheet, View, Image,Text,TextInput, ImageBackground, TouchableOpacity } from 'react-native';
import MaterialIcons from 'react-native-vector-icons/MaterialIcons';
import Foundation from 'react-native-vector-icons/Foundation';
import FontAwesome from 'react-native-vector-icons/FontAwesome';
import { useNavigation } from '@react-navigation/native';
import { AuthContext } from '../context/AuthContext';


const LoginScreen = () => {
  const {login} = useContext(AuthContext);
  const navigation = useNavigation();
  const [email, setEmail] = useState(null);
  const [password, setPassword] = useState(null);

  const handleRegister = () => {
    // Navigate to Register Screen
    navigation.navigate('Signup');
  };
  return (
    <View style={styles.containner}>
      <View style={styles.topImageContainner}>
        {/* Background Image */}
        <Image source={require('../assets/top1.png')} style={styles.topImage} />
        <Text style={styles.toptext}>Krishi Mitra</Text>
      </View>
      <View style={styles.loginContainer}>
        <Text style={styles.loginText}>
            Login
        </Text>
      </View>
      <View style={styles.inputContainer1}>
        <MaterialIcons name={'email'} size = {22} color = {'black'} style={styles.inputIcon}/>
        <TextInput style={styles.textInput} placeholder="Email" value={email} onChangeText={text => setEmail(text)}/>
      </View>
      <View style={styles.inputContainer2}>
        <Foundation name={'lock'} size = {24} color = {'black'} style={styles.inputIcon}/>
        <TextInput style={styles.textInput} placeholder="Password" secureTextEntry value={password} onChangeText={text => setPassword(text)}/>
      </View>
      <Text style={styles.forgetPasswordText}>
        Forgot Your Password?
      </Text>
      <View style={styles.logInButtonContainer} onPress={() =>{login();}}>
          <Text style={styles.logIn}>
            Login
          </Text>
      </View>
      <View style={styles.footerContainer}>
      <TouchableOpacity onPress={handleRegister}>
      <Text style={styles.footerText}>
        Don't have an account? <Text style={{ textDecorationLine: 'underline', fontWeight: 'bold', color: '#5DDC51'}}>
          SignUp
        </Text>
      </Text>
      </TouchableOpacity>
      </View>
      <View style={styles.footerContainer}>
      <TouchableOpacity onPress={handleRegister}>
      <View style={styles.socialMediaContainner}>
      <FontAwesome name={'facebook-square'} size = {26} color = {'#3D5A98'} style={styles.socialIcon}/>
      <FontAwesome name={'google'} size = {26} color = {'red'} style={styles.socialIcon}/>
      </View>
      </TouchableOpacity>
      </View>
      <View style={styles.footerImageContainer}>
        <ImageBackground source={require('../assets/bot2.png')} style={styles.footerImage}/>
      </View>
    </View>
  );
};

export default LoginScreen;

const styles = StyleSheet.create({
  containner: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    position: 'relative',
  },
  topImageContainner: {
    height: 230,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  topImage: {
    width: '110%',
    height: '120%',
    position: 'absolute',
  },
  toptext: {
    fontFamily: 'K2D-BoldItalic',
    fontSize: 35,
    color: 'white',
  },
  loginContainer: {

  },
  loginText: {
    marginRight: 100,
    textAlign: 'center',
    fontSize: 50,
    fontWeight: 'bold',
    fontFamily: 'K2D-BoldItalic',
    color: 'black',
  },
  inputContainer1: {
    height: 50,
    backgroundColor: '#FFFFFF',
    flexDirection: 'row',
    borderRadius: 20,
    marginHorizontal: 40,
    marginVertical: 40,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  inputContainer2: {
    marginTop: -15,
    height: 50,
    backgroundColor: '#FFFFFF',
    flexDirection: 'row',
    borderRadius: 20,
    marginHorizontal: 40,
    marginVertical: 40,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  inputIcon: {
    marginLeft: 20,
    marginRight: 10,
  },
  inputText: {
    flex: 0,
  },
  forgetPasswordText: {
    color: 'grey',
    textAlign: 'right',
    width: '90%',
    fontSize: 14,
    fontStyle: 'italic',
  },
  logInButtonContainer: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  logIn: {
    color: 'black',
    fontSize: 25,
    fontWeight: 'bold',
    textAlign: 'center',
    marginTop: 30,
    backgroundColor: '#c3c3c3',
    paddingVertical: 15,
    borderRadius: 30,
    marginHorizontal: 40,
    marginVertical: 40,
  },
  footerText:{
    color: 'grey',
    textAlign: 'center',
    fontSize: 14,
    fontStyle: 'italic',
  },
  footerImageContainer: {
    height: 230,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  footerImage: {
    width: '105%',
    height: '102%',
    position: 'absolute',
  },
  footerContainer: {
  },
  socialMediaContainner: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: 15,
    marginBottom: -10,
  },
  socialIcon: {
    backgroundColor: 'white',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
    margin: 10,
    padding: 10,
    borderRadius: 30,
  },
});
