import React from 'react';
import { FaBolt, FaBrain, FaTools, FaLock, FaPalette, FaBoxOpen } from 'react-icons/fa';

const features = [
    {
        icon: <FaBolt />,
        title: "Zero Friction",
        desc: "No special shell or environment to enter. It hooks directly into PowerShell so your muscle memory just works."
    },
    {
        icon: <FaBrain />,
        title: "AI Superpowers",
        desc: "Stuck on syntax? Just type `plz` and describe what you want. We translate it to the correct PowerShell command instantly."
    },
    {
        icon: <FaTools />,
        title: "Native Translation",
        desc: "We don't just alias. We intelligently translate flags and arguments from Bash to PowerShell on the fly."
    },
    {
        icon: <FaLock />,
        title: "Privacy Focused",
        desc: "Core commands run locally. AI requests interact with Gemini but your code stays on your machine."
    },
    {
        icon: <FaPalette />,
        title: "Modern Experience",
        desc: "Enjoy a setup that feels like 2026. Clean outputs, helpful error messages, and seamless updates."
    },
    {
        icon: <FaBoxOpen />,
        title: "Lightweight",
        desc: "Install in seconds. No heavy dependencies or background services slowing down your rig."
    }
];

const Features = () => {
    const styles = {
        section: { padding: '8rem 0' },
        header: { textAlign: 'center', marginBottom: '5rem' },
        h2: { fontSize: '2.5rem', fontWeight: 700, marginBottom: '1rem' },
        p: { color: 'var(--text-muted)', maxWidth: '500px', margin: '0 auto' },
        grid: {
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
            gap: '2rem',
        },
        card: {
            background: 'var(--bg-card)',
            border: '1px solid var(--border)',
            padding: '2rem',
            borderRadius: '16px',
            position: 'relative',
            overflow: 'hidden',
        },
        icon: {
            width: '48px',
            height: '48px',
            background: 'rgba(59, 130, 246, 0.1)',
            borderRadius: '12px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '1.5rem',
            marginBottom: '1.5rem',
            color: 'var(--primary)',
        },
        cardTitle: { fontSize: '1.25rem', marginBottom: '0.75rem', fontWeight: 600 },
        cardDesc: { color: 'var(--text-muted)', fontSize: '0.95rem' }
    };

    return (
        <section id="features" style={styles.section} className="container">
            <div style={styles.header}>
                <h2 style={styles.h2}>Built for Speed</h2>
                <p style={styles.p}>Designed to feel like a native part of your workflow. No context switching, just productivity.</p>
            </div>

            <div style={styles.grid}>
                {features.map((f, i) => (
                    <div key={i} className="feature-card" style={styles.card}>
                        <div style={styles.icon}>{f.icon}</div>
                        <h3 style={styles.cardTitle}>{f.title}</h3>
                        <p style={styles.cardDesc}>{f.desc}</p>
                    </div>
                ))}
            </div>

            <style jsx>{`
                .feature-card {
                    transition: all 0.3s ease;
                }
                .feature-card:hover {
                    transform: translateY(-5px);
                    background: var(--bg-card-hover);
                    border-color: rgba(59, 130, 246, 0.2);
                    box-shadow: 0 10px 40px -10px rgba(0,0,0,0.5);
                }
            `}</style>
        </section>
    );
};

export default Features;
