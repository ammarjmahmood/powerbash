import React from 'react';

const Terminal = () => {
    const styles = {
        container: {
            maxWidth: '900px',
            margin: '0 auto',
            position: 'relative',
        },
        glow: {
            content: "''",
            position: 'absolute',
            inset: '-20px',
            background: 'linear-gradient(180deg, rgba(59, 130, 246, 0.2) 0%, transparent 100%)',
            zIndex: -1,
            filter: 'blur(40px)',
            borderRadius: '20px',
            opacity: 0.6,
        },
        terminal: {
            background: 'rgba(15, 23, 42, 0.95)',
            border: '1px solid rgba(255, 255, 255, 0.1)',
            borderRadius: '12px',
            overflow: 'hidden',
            boxShadow: '0 20px 50px rgba(0, 0, 0, 0.5)',
            textAlign: 'left',
        },
        bar: {
            background: 'rgba(30, 41, 59, 0.5)',
            padding: '0.75rem 1rem',
            display: 'flex',
            alignItems: 'center',
            gap: '0.5rem',
            borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
        },
        dot: { width: '12px', height: '12px', borderRadius: '50%' },
        body: {
            padding: '1.5rem',
            color: '#e2e8f0',
            fontSize: '0.95rem',
            lineHeight: 1.8,
            minHeight: '300px',
        },
        cmdLine: { display: 'flex', gap: '0.75rem', marginBottom: '0.5rem' },
        prompt: { color: '#4ade80', fontWeight: 'bold', userSelect: 'none' },
        cmd: { color: '#f8fafc' },
        output: { color: '#94a3b8', marginBottom: '1.5rem' },
        cursor: {
            display: 'inline-block',
            width: '8px',
            height: '1.2em',
            background: '#94a3b8',
            verticalAlign: 'middle',
        }
    };

    return (
        <div style={styles.container}>
            <div style={styles.glow}></div>
            <div style={styles.terminal}>
                <div style={styles.bar}>
                    <div style={{ ...styles.dot, background: '#ef4444' }}></div>
                    <div style={{ ...styles.dot, background: '#f59e0b' }}></div>
                    <div style={{ ...styles.dot, background: '#22c55e' }}></div>
                    <span className="font-mono" style={{ fontSize: '0.8rem', color: '#64748b', marginLeft: '0.5rem' }}>User — PowerShell</span>
                </div>
                <div style={styles.body} className="font-mono">
                    <div style={styles.cmdLine}>
                        <span style={styles.prompt}>PS C:\Projects&gt;</span>
                        <span style={styles.cmd}>ls -la</span>
                    </div>
                    <div style={styles.output}>
                        drwxr-xr-x  youruser  staff   src<br />
                        -rw-r--r--  youruser  staff   README.md<br />
                        -rw-r--r--  youruser  staff   package.json
                    </div>

                    <div style={styles.cmdLine}>
                        <span style={styles.prompt}>PS C:\Projects&gt;</span>
                        <span style={styles.cmd}>plz find all python files larger than 1mb</span>
                    </div>
                    <div style={{ ...styles.output, color: 'var(--accent)' }}>
                        → Get-ChildItem -Recurse -Filter *.py | Where-Object &#123;$_.Length -gt 1MB&#125;
                    </div>
                    <div style={styles.output}>
                        Directory: C:\Projects\src\core<br />
                        -a----        2024-01-26     1056234    processor.py
                    </div>

                    <div style={styles.cmdLine}>
                        <span style={styles.prompt}>PS C:\Projects&gt;</span>
                        <span style={styles.cursor} className="animate-blink"></span>
                    </div>
                </div>
            </div>
            <style jsx>{`
                .animate-blink { animation: blink 1s step-end infinite; }
                @keyframes blink { 50% { opacity: 0; } }
            `}</style>
        </div>
    );
};

export default Terminal;
