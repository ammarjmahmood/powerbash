import React, { useState, useEffect } from 'react';
import { FaGithub } from 'react-icons/fa';

const Header = () => {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const styles = {
    header: {
      position: 'fixed',
      top: 0,
      width: '100%',
      zIndex: 50,
      borderBottom: '1px solid var(--border)',
      background: scrolled ? 'rgba(2, 6, 23, 0.8)' : 'transparent',
      backdropFilter: 'blur(12px)',
      transition: 'all 0.3s ease',
    },
    nav: {
      height: '80px',
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
    },
    brand: {
      fontWeight: 800,
      fontSize: '1.5rem',
      letterSpacing: '-0.02em',
      display: 'flex',
      alignItems: 'center',
      gap: '0.5rem',
    },
    brandSpan: {
      background: 'linear-gradient(135deg, #fff 0%, #94a3b8 100%)',
      WebkitBackgroundClip: 'text',
      WebkitTextFillColor: 'transparent',
    },
    navItems: {
      display: 'flex',
      gap: '2rem',
      fontSize: '0.95rem',
      fontWeight: 500,
      color: 'var(--text-muted)',
    },
    navLink: {
      cursor: 'pointer',
      transition: 'color 0.2s',
    },
    navLinkHover: {
      color: 'var(--text-main)',
    }
  };

  return (
    <header style={styles.header}>
      <div className="container">
        <nav style={styles.nav}>
          <div style={styles.brand}>
            <span style={styles.brandSpan}>⚡ PowerBash</span>
          </div>
          <div style={styles.navItems} className="nav-items-container">
            <a href="#features" style={styles.navLink}>Features</a>
            <a href="#commands" style={styles.navLink}>Commands</a>
            <a href="https://github.com/yourusername/powerbash" target="_blank" rel="noopener noreferrer" style={styles.navLink}>
              GitHub
            </a>
          </div>
        </nav>
      </div>
    </header>
  );
};

export default Header;
