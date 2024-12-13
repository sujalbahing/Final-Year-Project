/* eslint-disable react-native/no-inline-styles */
import React from 'react';
import { StyleSheet, View, Image,Text,TextInput, ImageBackground, TouchableOpacity } from 'react-native';
import FontAwesome from 'react-native-vector-icons/FontAwesome';
import Foundation from 'react-native-vector-icons/Foundation';
import MaterialIcons from 'react-native-vector-icons/MaterialIcons';
import { useNavigation } from '@react-navigation/native';


const SignupScreen = () => {

  const navigation = useNavigation();

  const handleRegister = () => {
    // Navigate to Register Screen
    navigation.navigate('Login');
  };
  return (
    <View style={styles.containner}>
      <View style={styles.topImageContainner}>
        {/* Background Image */}
        <Image source={require('../assets/top2.png')} style={styles.topImage} />
        <Text style={styles.toptext}>Krishi Mitra</Text>
      </View>
      <View style={styles.helloContainer}>
        <Text style={styles.createAccountText}>
            Create an account
        </Text>
      </View>
      <View style={styles.inputContainer1}>
        <FontAwesome name={'user'} size = {24} color = {'black'} style={styles.inputIcon}/>
        <TextInput style={styles.textInput} placeholder="Username"/>
      </View>
      <View style={styles.inputContainer3}>
        <MaterialIcons name={'email'} size = {22} color = {'black'} style={styles.inputIcon}/>
        <TextInput style={styles.textInput} placeholder="Email"/>
      </View>
      <View style={styles.inputContainer2}>
        <Foundation name={'lock'} size = {24} color = {'black'} style={styles.inputIcon}/>
        <TextInput style={styles.textInput} placeholder="Password" secureTextEntry/>
      </View>
      <View style={styles.inputContainer2}>
        <Foundation name={'lock'} size = {24} color = {'black'} style={styles.inputIcon}/>
        <TextInput style={styles.textInput} placeholder="Confirm Password" secureTextEntry/>
      </View>
      <View style={styles.signUpButtonContainer}>
          <Text style={styles.signUp}>
            Sign Up
          </Text>
      </View>
      <TouchableOpacity onPress={handleRegister}>
      <Text style={styles.footerText}>
        Already have an account? <Text style={{textDecorationLine: 'underline', fontWeight: 'bold', color: '#5DDC51'}}>
          Login
        </Text>
      </Text>
      </TouchableOpacity>
      <View style={styles.footerImageContainer}>
        <ImageBackground source={require('../assets/bot1.png')} style={styles.footerImage}/>
      </View>
    </View>
  );
};

export default SignupScreen;

const styles = StyleSheet.create({
  containner: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    position: 'relative',
  },
  topImageContainner: {
    height: 240,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  topImage: {
    width: '100%',
    height: '100%',
    position: 'absolute',
  },
  toptext: {
    fontFamily: 'K2D-BoldItalic',
    fontSize: 35,
    color: 'white',
    marginBottom: 30,
  },
  helloContainer: {
  },
  createAccountText: {
    marginTop: -18,
    marginRight: 40,
    textAlign: 'center',
    fontSize: 35,
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
  inputContainer3: {
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
    flex: 1,
    // paddingHorizontal: 10,
    // fontSize: 18,
    // color: 'grey',
  },
  signUpButtonContainer: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  signUp: {
    color: 'black',
    fontSize: 25,
    fontWeight: 'bold',
    textAlign: 'center',
    marginTop: 10,
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
    height: '70%',
    position: 'absolute',
  }});