import React, { useState } from 'react';
import { FaCopy, FaCheck } from 'react-icons/fa';
import Terminal from './Terminal';

const Hero = () => {
    const [copied, setCopied] = useState(false);
    const installCmd = "iwr -useb https://raw.githubusercontent.com/yourusername/powerbash/main/install.ps1 | iex";

    const handleCopy = () => {
        navigator.clipboard.writeText(installCmd);
        setCopied(true);
        setTimeout(() => setCopied(false), 2000);
    };

    const styles = {
        section: {
            paddingTop: '160px',
            paddingBottom: '80px',
            textAlign: 'center',
        },
        h1: {
            fontSize: 'clamp(3rem, 5vw, 4.5rem)',
            fontWeight: 800,
            lineHeight: 1.1,
            marginBottom: '1.5rem',
            letterSpacing: '-0.03em',
        },
        p: {
            fontSize: '1.25rem',
            color: 'var(--text-muted)',
            maxWidth: '600px',
            margin: '0 auto 2.5rem',
        },
        installBox: {
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '1rem',
            margin: '2rem 0',
        },
        copyBox: {
            background: '#1e1e1e',
            border: '1px solid #333',
            padding: '1rem 1.5rem',
            borderRadius: '8px',
            fontFamily: "'JetBrains Mono', monospace",
            fontSize: '0.9rem',
            color: '#d4d4d4',
            display: 'flex',
            alignItems: 'center',
            gap: '1rem',
            cursor: 'pointer',
            transition: 'border-color 0.2s, transform 0.1s',
            position: 'relative',
        },
        copyIcon: {
            color: copied ? '#22c55e' : '#666',
        },
        ctaGroup: {
            display: 'flex',
            justifyContent: 'center',
            flexWrap: 'wrap',
            gap: '1rem',
            marginBottom: '4rem',
        }
    };

    return (
        <section style={styles.section} className="container">
            <div className="badge">Open Source Developer Tool</div>
            <h1 style={styles.h1}>
                The power of Bash <br />
                <span className="gradient-text">Native to Windows</span>
            </h1>
            <p style={styles.p}>
                Finally, use `ls`, `grep`, and `python3` directly in PowerShell.
                Plus, control your terminal with AI-powered natural language.
            </p>

            <div style={styles.installBox}>
                <div
                    style={styles.copyBox}
                    onClick={handleCopy}
                    className="copy-box-hover"
                >
                    <span>
                        <span style={{ color: '#ef4444' }}>iwr</span> -useb .../install.ps1 | <span style={{ color: '#ef4444' }}>iex</span>
                    </span>
                    {copied ? <FaCheck style={styles.copyIcon} /> : <FaCopy style={styles.copyIcon} />}
                </div>
                <span style={{ fontSize: '0.8rem', color: '#475569', marginTop: '-5px' }}>
                    {copied ? 'Copied to clipboard!' : 'Click to copy install command'}
                </span>
            </div>

            <div style={styles.ctaGroup}>
                <a href="#install" className="btn btn-primary">Get Started</a>
                <a href="https://github.com/yourusername/powerbash" target="_blank" rel="noreferrer" className="btn btn-secondary">Star on GitHub</a>
            </div>

            <Terminal />

            <style jsx>{`
                .copy-box-hover:hover {
                    border-color: var(--primary);
                }
                .copy-box-hover:active {
                    transform: scale(0.98);
                }
            `}</style>
        </section>
    );
};

export default Hero;
