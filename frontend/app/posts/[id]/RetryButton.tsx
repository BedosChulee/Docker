'use client';

interface RetryButtonProps {
  className?: string;
}

export default function RetryButton({ className }: RetryButtonProps) {
  const handleRetry = () => {
    window.location.reload();
  };

  return (
    <button onClick={handleRetry} className={className}>
      Try Again
    </button>
  );
}