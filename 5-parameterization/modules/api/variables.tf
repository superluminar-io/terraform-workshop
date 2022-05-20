variable "environment" {
  type        = string
  description = "Identifier for the environment (e.g. staging, development or prod)"
}

variable "enable_greeting_feature" {
  type        = bool
  description = "Enable greeting feature"
  default     = false
}
