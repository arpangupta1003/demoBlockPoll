import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import {BrowserRouter} from 'react-router-dom'
import './index.css'
import { AuthProvider } from './auth/useAuth'
import Footer from './Components/Footer/Footer';  

ReactDOM.createRoot(document.getElementById('root')).render(
    <BrowserRouter>
      <AuthProvider>
        <App/>
        {/* <Footer/> */}
      </AuthProvider>  
    </BrowserRouter>
)
