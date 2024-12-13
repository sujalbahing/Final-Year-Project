import React, { createContext, useEffect, useState } from 'react';
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isLoading, setIsLoading] = useState(false);
  const [userToken, setUserToken] = useState(null);
  const [userInfo, setUserInfo] = useState(null);

  const BASE_URL = 'http://127.0.0.1:8000/api/user'; // Replace with your backend URL

  const login = async (email, password) => {
    setIsLoading(true);
    try {
      const res = await axios.post(`${BASE_URL}/api/login/`, {
        email,
        password,
      });
      const userInfo = res.data;
      setUserInfo(userInfo);
      setUserToken(userInfo.token.access); // Store access token
      await AsyncStorage.setItem('userToken', userInfo.token.access);
      console.log('Login successful:', userInfo);
    } catch (error) {
      console.error('Login error:', error.response?.data || error.message);
    }
    setIsLoading(false);
  };

  const register = async (email, name, password, password2, tc) => {
    setIsLoading(true);
    try {
      const res = await axios.post(`${BASE_URL}/api/register/`, {
        email,
        name,
        password,
        password2,
        tc,
      });
      console.log('Registration successful:', res.data);
    } catch (error) {
      console.error('Registration error:', error.response?.data || error.message);
    }
    setIsLoading(false);
  };

  const logout = async () => {
    setIsLoading(true);
    try {
    //   await AsyncStorage.removeItem('userToken');
      setUserToken(null);
      setUserInfo(null);
      console.log('Logout successful');
    } catch (error) {
      console.error('Logout error:', error.message);
    }
    setIsLoading(false);
  };

  const isLoggedIn = async () => {
    try {
      setIsLoading(true);
      const token = await AsyncStorage.getItem('userToken');
      if (token) {
        setUserToken(token);
        console.log('User token found:', token);
      }
    } catch (error) {
      console.error('isLoggedIn error:', error.message);
    }
    setIsLoading(false);
  };

  useEffect(() => {
    isLoggedIn();
  }, []);

  return (
    <AuthContext.Provider value={{ login, register, logout, isLoading, userToken, userInfo }}>
      {children}
    </AuthContext.Provider>
  );
};
