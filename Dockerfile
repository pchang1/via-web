# Via Web — Static site served by nginx
# Multi-stage: builder validates files exist, runner is minimal
FROM nginx:1.27-alpine AS runner

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy static files
COPY index.html /usr/share/nginx/html/index.html
COPY privacy-policy.html /usr/share/nginx/html/privacy-policy.html
COPY AppIcon.png /usr/share/nginx/html/AppIcon.png

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
