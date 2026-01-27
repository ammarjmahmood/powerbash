import React from 'react';

const cmdList = [
    "ls", "cd", "pwd", "cat", "grep", "find", "mkdir", "rm", "cp", "mv",
    "touch", "head", "tail", "wc", "sort", "uniq", "cut", "sed", "awk",
    "tar", "zip", "unzip", "curl", "wget", "ping", "whoami", "ps", "kill",
    "top", "df", "du", "free", "clear", "history", "export", "alias",
    "sudo", "chmod", "chown", "ssh", "git", "vim", "nano", "diff", "less",
    "which", "date", "cal"
];

const Commands = () => {
    const styles = {
        section: { padding: '4rem 0 8rem' },
        header: { textAlign: 'center', marginBottom: '2rem' },
        h2: { fontSize: '2.5rem', fontWeight: 700, marginBottom: '1rem' },
        grid: {
            display: 'flex',
            flexWrap: 'wrap',
            justifyContent: 'center',
            gap: '0.75rem',
            maxWidth: '1000px',
            margin: '0 auto',
        },
        pill: {
            background: 'rgba(255, 255, 255, 0.03)',
            border: '1px solid rgba(255, 255, 255, 0.05)',
            padding: '0.5rem 1rem',
            borderRadius: '6px',
            fontFamily: "'JetBrains Mono', monospace",
            fontSize: '0.85rem',
            color: 'var(--text-muted)',
            transition: 'all 0.2s',
            cursor: 'default',
        }
    };

    return (
        <section id="commands" style={styles.section} className="container">
            <div style={styles.header}>
                <h2 style={styles.h2}>60+ Supported Commands</h2>
                <p style={{ color: 'var(--text-muted)' }}>From `ls` to `grep`, we've got you covered.</p>
            </div>

            <div style={styles.grid}>
                {cmdList.map((cmd) => (
                    <div key={cmd} className="cmd-pill" style={styles.pill}>
                        {cmd}
                    </div>
                ))}
            </div>

            <style jsx>{`
                .cmd-pill:hover {
                    background: rgba(6, 182, 212, 0.1) !important;
                    color: var(--accent) !important;
                    border-color: rgba(6, 182, 212, 0.3) !important;
                    transform: scale(1.05);
                }
            `}</style>
        </section>
    );
};

export default Commands;
