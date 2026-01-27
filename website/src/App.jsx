import React from 'react'
import Header from './components/Header'
import Hero from './components/Hero'
import Features from './components/Features'
import Commands from './components/Commands'
import Footer from './components/Footer'

function App() {
  return (
    <>
      <div className="bg-grid"></div>
      <div className="bg-glow"></div>

      <Header />

      <main>
        <Hero />
        <Features />
        <Commands />
      </main>

      <Footer />
    </>
  )
}

export default App
