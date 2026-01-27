import React from 'react';

const Footer = () => {
    const styles = {
        footer: {
            borderTop: '1px solid var(--border)',
            padding: '4rem 0',
            background: '#020617',
            textAlign: 'center',
        },
        logo: {
            fontWeight: 700,
            fontSize: '1.25rem',
            marginBottom: '1rem',
            color: '#fff',
        },
        nav: {
            display: 'flex',
            justifyContent: 'center',
            gap: '2rem',
            marginBottom: '2rem',
        },
        link: {
            color: 'var(--text-muted)',
            fontSize: '0.9rem',
            transition: 'color 0.2s',
        },
        copyright: {
            color: '#475569',
            fontSize: '0.8rem',
        }
    };

    return (
        <footer style={styles.footer}>
            <div className="container">
                <div style={styles.logo}>⚡ PowerBash</div>
                <div style={styles.nav}>
                    <a href="#" className="footer-link" style={styles.link}>Documentation</a>
                    <a href="#" className="footer-link" style={styles.link}>Privacy</a>
                    <a href="https://github.com/yourusername/powerbash" className="footer-link" style={styles.link}>GitHub</a>
                    <a href="#" className="footer-link" style={styles.link}>Twitter</a>
                </div>
                <p style={styles.copyright}>© 2026 PowerBash. Open Source MIT License.</p>
            </div>
            <style jsx>{`
                .footer-link:hover { color: var(--primary) !important; }
            `}</style>
        </footer>
    );
};

export default Footer;
